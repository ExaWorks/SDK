---
name: Request for including into CI
description: Use this template to create a request for including a software tool into CI pipelines per facility.
title: "[CI Request]: [SOFTWARE TOOL NAME]"
labels: "Continuous Integration"
assignees: "mtitov, danlaney"
---

Please fullfil the initial requirements from the following document: 
[Contributing to SDK](https://exaworkssdk.readthedocs.io/en/latest/contribute.html).

1. **CI Request** includes the following information about the software tool:

- [ ] Description of the tool
- [ ] GitHub repository (URL)
- [ ] Supported package managers: **pip**, **conda**, **spack**
- [ ] Specific version to be used (i.e., "stable") and possibility to run 
      **the latest** version is optional
- [ ] List of all dependencies
  - Direct dependencies
  - Transitive dependencies (dependencies of dependencies)
- [ ] CI facility: **preferred ones** or **all available** 

2. After this request is approved, you will be notified and asked to create
   a **Pull Request** with basic tests (tests recipe) packed into `test.sh` inside
   the directory `ci/tests/<tool_name>`.

3. With all passed steps above, your tool will be activated in all requested
   CI pipelines.

