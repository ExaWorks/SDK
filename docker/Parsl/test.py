#!/usr/bin/python3

import parsl
import os
from parsl.app.app import python_app, bash_app
from parsl.configs.local_threads import config

#parsl.set_stream_logger() # <-- log everything to stdout

print(parsl.__version__)

parsl.load(config)

@python_app
def hello ():
    return 'Hello World from Python!'

print(hello().result())

@bash_app
def echo_hello(stdout='/tmp/echo-hello.stdout', stderr='/tmp/echo-hello.stderr'):
    return 'echo "Hello World!"'

echo_hello().result()

with open('/tmp/echo-hello.stdout', 'r') as f:
    print(f.read())
