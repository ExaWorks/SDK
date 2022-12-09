.. _chapter_tutorials:

=========
Tutorials
=========

In the following, we offer a brief tutorials for how to write an `hello_world`
application with each Exaworks SDK core component, how to prepare and run
Exaworks SDK Docker container, and how to Exaworks SDK tests. We also offer
details that might be useful for developers that would like to contribute to
Exaworks SDK.


Running the Tutorials
---------------------

Tutorials can be run via our self-contained Docker container or independently.
When run independently, the user has to setup a suitable running environment for
each tutorial. That can be technically demanding and it requires referring to
the documentation site of each component.

To run the tutorials in the ExaWorks SDK Docker container:

1. clone the ExaWorks SDK repository:

  ```
  clone
  ```

2. Follow the instructions in `SDK/docker/tutorials/README.md <https://github.com/ExaWorks/SDK/blob/master/docker/tutorials/README.md>`_, choosing one
   of the three methods A, B or C to execute your container. Note that if you
   want to run the RADICAL-Cybertools tutorial, you will have to chose either B
   or C.
3. After following the instructions, you will be given a URI to cut and paste in
   your browser to access to the Jupyter Notebook server that is running in the
   SDK container.
4. Load and execute each tutorial in the Jupyter Notebook server on your
   browser.
5. Once finished, stop the SDK container and, in case, the MongoDB and RabbitMQ
   containers you started to execute the RADICAL-Cybertools tutorial.


SDK Core Components Tutorials
-----------------------------

* `Flux <tutorials/flux.ipynb>`_
* `Parsl <tutorials/parsl/parsl.ipynb>`_
* `PSI/J <tutorials/psij.ipynb>`_
* `RADICAL-Cybertools <tutorials/rct.ipynb>`_
* `Swift/T <tutorials/swift.ipynb>`_

