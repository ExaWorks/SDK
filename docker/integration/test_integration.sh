#!/bin/bash

set -e

flux start python3 -m pytest $(python3 -c \
	"import parsl.tests.test_flux as tf; print(tf.__file__)") \
	--config=local --tap-stream
