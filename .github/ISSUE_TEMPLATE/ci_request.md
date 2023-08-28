---
name: Request to include a software tool into the CI
description: Use this template to create a request for including a software tool into CI pipelines for one or more facilities.
title: "[CI Request]: [SOFTWARE TOOL NAME]"
labels: "Continuous Integration"
assignees: "mtitov, danlaney"
---

Please fullfil the initial requirements described in [Contributing to SDK](https://exaworkssdk.readthedocs.io/en/latest/contribute.html).

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

2. After this request is approved, you will be notified and asked to create a **Pull Request** with basic test recipes packed into `test.sh` inside the directory `ci/tests/<tool_name>`.

3. Once all the steps above have been completed, your tool will be activated in all the requested CI pipelines.
