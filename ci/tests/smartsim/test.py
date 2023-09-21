import argparse
import io
import multiprocessing as mp
import socket
import tempfile
from contextlib import contextmanager

import numpy as np
from smartredis import Client

from smartsim import Experiment
from smartsim._core.utils.helpers import installed_redisai_backends
from smartsim.log import get_logger

_logger = get_logger("Smart", fmt="[%(name)s] %(levelname)s %(message)s")


def main(args):
    """Validate the SmartSim installation and ML dependencies
    work as expected given a simple experiment.
    """
    backends = installed_redisai_backends()
    try:
        with tempfile.TemporaryDirectory() as temp_dir:
            test_install(
                location=temp_dir,
                port=args.port,
                device=args.device.upper(),
                with_tf="tensorflow" in backends,
                with_pt="torch" in backends,
                with_onnx="onnxruntime" in backends,
            )
    except Exception as e:
        _logger.error(
            "SmartSim failed to run a simple experiment!\n"
            f"Experiment failed due to the following exception:\n{e}\n\n"
        )
        return 123
    return 0


def test_install(location, port, device, with_tf, with_pt, with_onnx):
    exp = Experiment(
        "ValidationExperiment", exp_path=location, launcher="local"
    )
    port = _find_free_port() if port is None else port
    with _make_managed_local_orc(exp, port) as client:
        _logger.info("Verifying Tensor Transfer")
        client.put_tensor("plain-tensor", np.ones((1, 1, 3, 3)))
        client.get_tensor("plain-tensor")
        if with_tf:
            _logger.info("Verifying TensorFlow Backend")
            _test_tf_install(client, location, device)
        if with_pt:
            _logger.info("Verifying Torch Backend")
            _test_torch_install(client, device)
        if with_onnx:
            _logger.info("Verifying ONNX Backend")
            _test_onnx_install(client, device)


@contextmanager
def _make_managed_local_orc(exp, port):
    """Context managed orc that will be stopped if an exception is raised"""
    orc = exp.create_database(db_nodes=1, interface="lo", port=port)
    exp.generate(orc)
    exp.start(orc)
    try:
        client_addr ,= orc.get_address()
        yield Client(address=client_addr, cluster=False)
    finally:
        exp.stop(orc)


def _find_free_port():
    """A 'good enough' way to find an open port to bind to"""
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        sock.bind(("0.0.0.0", 0))
        _, port = sock.getsockname()
        return int(port)


def _test_tf_install(client, tmp_dir, device):
    recv_conn, send_conn = mp.Pipe(duplex=False)
    # Build the model in a subproc so that keras does not hog the gpu
    proc = mp.Process(target=_build_tf_frozen_model, args=(send_conn, tmp_dir))
    proc.start()

    # Do not need the sending connection in this proc anymore
    send_conn.close()

    proc.join(timeout=120)
    if proc.is_alive():
        proc.terminate()
        raise Exception(
            "Failed to build a simple keras model within 2 minutes"
        )
    try:
        model_path, inputs, outputs = recv_conn.recv()
    except EOFError as e:
        raise Exception(
            "Failed to receive serialized model from subprocess. "
            "Is the `tensorflow` python package installed?"
        ) from e

    client.set_model_from_file(
        "keras-fcn",
        model_path,
        "TF",
        device=device,
        inputs=inputs,
        outputs=outputs,
    )
    client.put_tensor(
        "keras-input", np.random.rand(1, 28, 28).astype(np.float32)
    )
    client.run_model(
        "keras-fcn", inputs=["keras-input"], outputs=["keras-output"]
    )
    client.get_tensor("keras-output")


def _build_tf_frozen_model(conn, tmp_dir):
    from tensorflow import keras

    from smartsim.ml.tf import freeze_model

    fcn = keras.Sequential(
        layers=[
            keras.layers.InputLayer(input_shape=(28, 28), name="input"),
            keras.layers.Flatten(input_shape=(28, 28), name="flatten"),
            keras.layers.Dense(128, activation="relu", name="dense"),
            keras.layers.Dense(10, activation="softmax", name="output"),
        ],
        name="FullyConnectedNetwork",
    )
    fcn.compile(
        optimizer="adam",
        loss="sparse_categorical_crossentropy",
        metrics=["accuracy"],
    )
    model_path, inputs, outputs = freeze_model(fcn, tmp_dir, "keras_model.pb")
    conn.send((model_path, inputs, outputs))


def _test_torch_install(client, device):
    import torch
    from torch import nn

    class Net(nn.Module):
        def __init__(self):
            super().__init__()
            self.conv = nn.Conv2d(1, 1, 3)

        def forward(self, x):
            return self.conv(x)

    net = Net()
    forward_input = torch.rand(1, 1, 3, 3)
    traced = torch.jit.trace(net, forward_input)
    buffer = io.BytesIO()
    torch.jit.save(traced, buffer)
    model = buffer.getvalue()

    client.set_model("torch-nn", model, backend="TORCH", device=device)
    client.put_tensor("torch-in", torch.rand(1, 1, 3, 3).numpy())
    client.run_model("torch-nn", inputs=["torch-in"], outputs=["torch-out"])
    client.get_tensor("torch-out")


def _test_onnx_install(client, device):
    from skl2onnx import to_onnx
    from sklearn.cluster import KMeans

    data = np.arange(20, dtype=np.float32).reshape(10, 2)
    model = KMeans(n_clusters=2)
    model.fit(data)

    kmeans = to_onnx(model, data, target_opset=11)
    model = kmeans.SerializeToString()
    sample = np.arange(20, dtype=np.float32).reshape(10, 2)

    client.put_tensor("onnx-input", sample)
    client.set_model("onnx-kmeans", model, "ONNX", device=device)
    client.run_model(
        "onnx-kmeans",
        inputs=["onnx-input"],
        outputs=["onnx-labels", "onnx-transform"],
    )
    client.get_tensor("onnx-labels")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        prog="SmartSim Validation Script",
        description=(
            "A smoke test to ensure that SmartSim and its ML dependencies"
            "are installed correctly."
        ),
    )
    parser.add_argument(
        "-p",
        "--port",
        type=int,
        default=None,
        help=(
            "The port on which to run the orchestrator for the mini "
            "experiment. If not provided, this script will attempt to "
            "automatically select an open port"
        ),
    )
    parser.add_argument(
        "--device",
        type=str.lower,
        default="cpu",
        choices=["cpu", "gpu"],
        help="Device to test the ML backends against",
    )
    raise SystemExit(main(parser.parse_args()))
