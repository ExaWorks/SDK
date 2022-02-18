.. _chapter_components:

===============
Core Components
===============

The SDK has four core components but it is open to the contribution of any system that support the execution of scientific workflows on the Departiment of Energy high performance computing platforms.

*  `Flux <http://flux-framework.org>`_. Workload management system (à la Slurm, PBS, LSF), with single-user and multi-user (a.k.a. system instance) modes.
*  `Parsl <https://parsl-project.org>`_. Pure Python library for describing and managing parallel computation on one to many nodes.  It contains abstractions to support various parallel and distributed workloads: from bag-of-tasks to dataflow, short to long duration tasks, single core through to multi-node.
*  `PSI/J <https://github.com/ExaWorks/psi-j-python>`_. The Portable Submission Interface for Jobs TODO: add description here.
*  `RADICAL-Cybertools <https://radical-cybertools.github.io>`_. `RADICAL-EnsembleToolkit (EnTK) <https://radicalentk.readthedocs.io/en/stable/>`_ and `RADICAL-Pilot (RP) <https://radicalpilot.readthedocs.io/en/stable/>`_ are middleware architected for scalability, interoperability and sustainability. Implemented as Python modules, they support the execution of scientific workflows and workloads on a range of high-performance and distributed computing platforms.
* `Swift/T <http://swift-lang.org/Swift-T>`_. Swift/T is an MPI-based workflow language and runtime system.  It runs in a one big job model, with internal automatic task parallelization and data movement, enhanced by workflow-level compiler optimizations.

Installation
------------

Each core component can be indipendently installed by following the instructions of each component's documentation. Exaworks SDK curates the containarization of each component and its `Spack <https://computing.llnl.gov/projects/spack-hpc-package-manager>`_ packaging.

Containers
++++++++++

TODO: Add here instructions for installing and using the containerized core components.

Spack packages
++++++++++++++

TODO: Add here instructions for installing and using the spack package of each core component.
