.. _chapter_tutorial:

=========
Tutorials
=========

In the following, we offer a brief tutorial for each Exaworks SDK core component.

Flux
----

Parsl
-----

PSI/J
-----

RADICAL-Cybertools
------------------

RADICAL-Cybertools support the execution of ensemble applications at scale on
high performance computing (HPC) platforms. Ensamble applications enable using
diverse algorithms to coordinate the execution of up to 10^6 tasks on all the
processors (CPU/GPU) of an HPC machine. This type of applications are common in
biophysical systems, climate science, seismology, and polar science domains.
RADICAL-Cybertools address challenges of scale, diversity and reliability.

Adaptive ensemble are a particularly interesting type of ensemble applications
in which adaptivity is used to determine the behavior of the application at
runtime. For example, many biomolecular sampling algorithms are formulated as
adaptive: replica-exchange, Expanded Ensemble, etc. Introducing adaptivity,
improved simulation efficiency of up to a factor three but implementing adaptive
ensemble applications is challenging due to the compleixity of the required
algorithms.

RADICAL-Cybertools offers RADICAL-EnsembleToolkit (EnTK), a workflow engine
specifically designed to support the execution of (adaptive) ensemble
applications at scale on HPC platforms. EnTK allows usrs to separate adaptive
logic and simulation/analysis code, while abtracting away from the users issues
of resource management and resource management and runtime execution
coordination. EnTK exposes a simple application programming interface,
implemented in Python and with two (Pythonic) collections of objects and three
classes:

* Set: contains objects that have no relative order with each other
* Sequence/List: contains objects that have a linear order, i.e. object 'i'
  depends on object 'i-1'
* Task: description of executing kernel
* Stage: set of Tasks, i.e. all tasks of a stage may execute concurrently
* Pipeline: sequence of Stages, i.e. Stage 2 may only commence after Stage 1
  completes

Thus, in EnTK an ensemble application is described as a set of Pipelines.

Prepare Execution Environment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

TODO: decide how to make the example environment available. Consider converting
this to executable notebooks.

Example 1: Ensemble of Simulation Pipelines
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In this example, the ensemble application consists of two pipelines, each with
three stages called Seed, Simulate and Analyze. The Seed and Analyze stages
contain one task while the Simulate pipeline consists of multiple tasks (see
Figure 1).

.. image:: tutotials/images/entk_example1_app.png
   :alt: Example 1 ensemble application with 2 pipelines

The two pipelines execute concurrently and, as per EnTK API definitions, each
stage inside each pipeline executes sequentially. Importantly, when a stage
cotains **multiple** tasks, all those tasks can execute concurrently, assuming
that enough resources are available. Given a set of resources, EnTK always
executes the esemble application with the highest possible degree of concurrency
but, when not enough resources are available, the tasks of a stage may be
executed sequentially. All this is transparent to the user that is left free to
focus on the ensemble algorithm without having to deal with parallelism and
reosurce management.

TODO: Depending on how we want to provide the tutorial code, add example
code/instructions here.

Exercises:

1. Switch execution backend to use FLUX instead of default ``fork/exec`` (RCT
   execution backends include  ``Slurm``, ``LSF``, ``APRUN``, ``PRTE``,
   ``mpirun/mpiexec``, ``ibrun``, etc.):

 - Look at the ``appman.resource_desc`` in the  program's ``main`` section
 - Solution is in ``solution_1.1.py``

2. Change the number of ensemble members (number of pipelines) and number of
   simulations per pipeline:

 - VM has only 2 cores, please be gentle ;-)
 - Look at the ``for`` loop in the program's ``main`` section
 - Look at the construction of Stage 2 (``s2``)
 - Solution is in ``solution_1.2.py``

3. Add a fourth stage which computes the square root of the sum:

 - The kernel could be something like: ``echo "sqrt($(cat sum.txt))" | bc``
 - Output staging should move from previous last stage (``s3``) to the new stage (``s4``)
 - Solution is in ``solution_1.3.py``

Example 2: Ensemble of Dynamic Pipelines
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In this example, the ensemble application still consists of two Pipelines but, after each simulation stage, it checks the results and:
* **if** divergent: re-seed the pipeline
* **elif** convergent: finish pipeline
* **else**: continue simulation

The ensemble application uses the Stage ``post_exec`` directives to decide on pipeline progression:
* Intermediate data are staged out
* New stages are added dynamically
* Pipelines are completed as needed

As showed by Figure 2, the application adapts based on the partial results of
the simulation stages. Thus, the number of stages per application is not
predefined but determined at runtime, depending on the simulation results.

.. image:: tutotials/images/entk_example2_app.png
   :alt: Example 2 adaptive ensemble application with 2 dynamic pipelines

TODO: Depending on how we want to provide the tutorial code, add example
code/instructions here.

**Exercise**:

Calculating intermediate results is costly: all data need to be staged back and analyzed.
Instead, insert a ``stage 2b`` which analyzes data on the target resource and
only then stages back the result to decide about pipeline continuation:
* This exercise is very similar to Example 1, exercise 3
* ``stage 2b`` would be very similar to ``stage 3``
* Consider what stage then needs to hold the ``post_exec``
* Solution is in ``solution_2.1.py``
* **Note**: you can turn off the reporter output with ``export RADICAL_REPORT=False``.

Swift/T
-------

