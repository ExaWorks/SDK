# Introduction and Goals
The ExaWorks SDK aims to support the workflow needs of a diverse range of users, administrators, and developers. It will enable teams to produce scalable and portable workflows for a wide range of exascale applications. The SDK will not replace the many workflow solutions already deployed and used by scientists, but rather it will provide a robust collection of community-identified technologies and components that can be leveraged by users.  Most importantly, the SDK will enable a sustainable software infrastructure for workflows so that the software artifacts produced by teams will be easier to port, modify, and utilize long after projects end. 

This document outlines the policies and recommendations for inclusion in the ExaWorks SDK. The policies are based on those defined by the xSDK and LLNL RADIUSS projects and reflect best practices for open source development, development of sustainable software, and scalable deployment of software on ECP systems.  

* M indicates a mandatory policy
* R indicates a recommended policy

## Licensing
M: Use an OSI-approved open-source license (e.g., Apache, MIT, BSD, LGPL)

R: Provide a list of dependencies and their licenses in a standard format (e.g., SPDX)

## Code
M: Code should be version controlled and publicly accessible online

M: Provide a transparent, online contribution process based on published contributing guide, and using pull requests and issues collection

R: Code should be version controlled using Git and accessible on GitHub

R: Follow a common style guide for code layout, documentation, naming, etc. (e.g., PEP8)

## Packaging
M: Package and provide automated builds using Spack and Conda

M: Use a limited, unique, and well-defined symbol, macro, library, include, and/or module namespace.

## Software design
M: Provide configurable logging that adheres to standard logging approaches

M: Use MPI in a way that is compatible with other products.  (expand meaning: multiple tools using MPI at the same time vs. leveraging multiple MPI implementations)

M: Provide a runtime API to return the current version of the software and system configuration

## Documentation
M: Include user documentation with the source code

M: Include up-to-date user documentation in the release cycle of the documented source code

M: User documentation should at least provide: (1) concise description of the project; (2) tutorial on how to use the documented code; and (3) details about how to contact the development team.

M: Include a policy for handling pull requests from external contributors. 

R: Write documentation in a format that can be automatically converted into other formats. E.g., markdown or reStructuredText.

R: Publish documentation in a web-based format, e.g., using readthedocs.

## Testing and continuous integration
M: Provide a comprehensive test suite for verifying correctness of build and installation.

M: Use regression tests in the development process.

M: Use continuous integration (CI).

R: Measure and record test coverage as part of CI

## Portability
M: Give best effort at portability to common HPC platforms, schedulers, and software.
