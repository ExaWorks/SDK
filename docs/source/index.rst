ExaWorks: Software Development Kit
==================================

.. image:: https://readthedocs.org/projects/exaworkssdk/badge/?version=latest
   :target: http://radicalanalytics.readthedocs.io/en/latest/?badge=latest
   :alt: Documentation Status

ExaWorks **Software Development Kit (SDK)** offers: (1) packaging for a curated
set of workflow software systems; (2) testing of those systems on a number of
high performance computing (HPC) platforms managed by the USA Department of
Energy (DoE); and (3) tutorials about coding workflow applications with those
workflow systems on DoE HPC platforms.

Exaworks SDK supports the workflows needs of diverse users, administrators, and
developers. It enables teams to produce scalable and portable workflows for a
wide range of exascale applications. SDK does not replace the many workflow
solutions already deployed and used by scientists, but rather it provides a
packaged, tested and documented collection of community-identified components
that can be leveraged by users. SDK contributes to enabling a sustainable
software infrastructure for workflows, supporting diverse scientific communities
on a variety of DoE HPC platforms.

Currently, ExaWorks SDK offers Docker containers and `Spack
<https://spack.readthedocs.io/>`_ packages for `Flux
<http://flux-framework.org>`_, `Parsl <https://parsl-project.org>`_, `PSI/J
<https://exaworks.org/psi-j-python/>`_, `RADICAL-Cybertools
<https://radical-cybertools.github.io>`_, and `Swift/T
<http://swift-lang.org/Swift-T>`_. Each package is deployed and tested on a
growing number of DoE HPC platforms. Applications teams can draw from SDK's
tutorials, levaraging containers and packages as needed to develop application
workflows.


.. note::

   This project is under active development.


.. toctree::
   :numbered:
   :maxdepth: 2

   .. introduction.rst
   components.rst
   .. usage.rst
   tutorials.rst
   contribute.rst
   .. development.rst


Indices and tables
------------------

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
