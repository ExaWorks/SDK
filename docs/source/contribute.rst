.. _chapter_contributing:

============
Contributing
============

This document outlines the policies and recommendations for inclusion in the
ExaWorks SDK. The policies are based on those defined by the xSDK and LLNL
RADIUSS projects and reflect best practices for open source development,
development of sustainable software, and scalable deployment of software on ECP
systems.

- **M** indicates a mandatory policy
- **R** indicates a recommended policy

Licensing
---------

- M: Use an OSI-approved open-source license (e.g., Apache, MIT, BSD, LGPL)
- R: Provide a list of dependencies and their licenses in a standard format
  (e.g., SPDX)

Code
----

- M: Code should be version controlled and publicly accessible online
- M: Provide a transparent, online contribution process based on published
  contributing guide, and using pull requests and issues collection
- R: Code should be version controlled using Git and accessible on GitHub
- R: Follow a common style guide for code layout, documentation, naming, etc.
  (e.g., PEP8)

Packaging
---------

- M: Package and provide automated builds using Spack and Conda
- M: Use a limited, unique, and well-defined symbol, macro, library, include,
  and/or module namespace.

Software design
---------------

- M: Provide configurable logging that adheres to standard logging approaches.
- M: Use MPI in a way that is compatible with other products, i.e., multiple
  tools using MPI at the same time vs. leveraging multiple MPI implementations).
- M: Provide a runtime API to return the current version of the software and
  system configuration.

Documentation
-------------

- M: Publish documentation in a web-based format.
- M: Provide a concise description of the project.
- M: Version control documentation consistent with and alongside source code.
- M: Provide a documented, reliable way to contact the development team.
- M: Provide and maintain example source code along with documentation.
- M: Provide a documented policy for handling pull requests from external
  contributors.

Testing and continuous integration
----------------------------------

- M: Provide a comprehensive test suite for verifying correctness of build and
  installation.
- M: Use regression tests in the development process.
- M: Use continuous integration (CI).
- R: Measure and record test coverage as part of CI

Portability
-----------

- M: Give best effort at portability to common HPC platforms, schedulers, and
  software.
