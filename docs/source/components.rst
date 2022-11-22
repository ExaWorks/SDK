.. _chapter_components:

===============
Core Components
===============

The SDK has four core components but it is open to the contribution of any system that support the execution of scientific workflows on the Department of Energy high performance computing platforms.

* `Flux <http://flux-framework.org>`_. Workload management system (à la Slurm, PBS, LSF), with single-user and multi-user (a.k.a. system instance) modes.
* `Parsl <https://parsl-project.org>`_. Pure Python library for describing and managing parallel computation on one to many nodes.  It contains abstractions to support various parallel and distributed workloads: from bag-of-tasks to dataflow, short to long duration tasks, single core through to multi-node.
* `PSI/J <https://exaworks.org/psi-j-python/>`_. The Portable Submission Interface for Jobs is a Python abstraction layer over cluster schedulers. A number of executors and launchers allow PSI/J to communicate with specific job schedulers.
* `RADICAL-Cybertools <https://radical-cybertools.github.io>`_. `RADICAL-EnsembleToolkit (EnTK) <https://radicalentk.readthedocs.io/en/stable/>`_ and `RADICAL-Pilot (RP) <https://radicalpilot.readthedocs.io/en/stable/>`_ are middleware architected for scalability, interoperability and sustainability. Implemented as Python modules, they support the execution of scientific workflows and workloads on a range of high-performance and distributed computing platforms.
* `Swift/T <http://swift-lang.org/Swift-T>`_. Swift/T is an MPI-based workflow language and runtime system.  It runs in a one big job model, with internal automatic task parallelization and data movement, enhanced by workflow-level compiler optimizations.

Installation
------------

Each core component can be indipendently installed by following the instructions of each component's documentation. Exaworks SDK curates the containarization of each component and its `Spack <https://computing.llnl.gov/projects/spack-hpc-package-manager>`_ packaging.

Containers
++++++++++

ExaWorks SDK packages are available via container from docker hub. The
following code shows how to access the SDK container image locally without
installation.

::

    docker pull exaworks/sdk
    docker run -it exaworks/sdk bash

The following code shows how to use the container images to run the notebook
tutorials. Note that the specific notebook you want to run may have some
additional prerequisites.

::

    docker run -p 8888:8888 -v path/to/notebooks:/notebooks -it exaworks/sdk bash
    pip install jupyter
    cd /notebooks
    jupyter notebook --allow-root --ip 0.0.0.0 --no-browser

Spack packages
++++++++++++++

ExaWorks SDK packages are packed together into Spack ``exaworks`` package. The
following code shows its installation within a corresponding Spack environment

::

    spack env create exaworkssdk
    spack env activate exaworkssdk
    spack install exaworks

If Spack is not in the system, then it could be installed manually

::

    git clone https://github.com/spack/spack.git
    . spack/share/spack/setup-env.sh

Steps for package creation are provided in `Packaging section <packaging.rst>`_.
For additional information please refer to `the Spack documentation <https://spack.readthedocs.io/en/latest/>`_.