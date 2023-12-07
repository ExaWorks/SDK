# Troubleshooting

## Environment variables

The following environment variables should be set within CI/CD settings:
- `SDK_DASHBOARD_URL` - used to publish results from the executed tests;
- `SDK_DASHBOARD_TOKEN` - unique token per facility (randomly generated UUID);
- `SDK_WORK_DIR` - working directory in a shared space;
   - In case of OLCF: `SDK_WORK_DIR_OPEN`, `SDK_WORK_DIR_ALPINE`, 
     `SDK_WORK_DIR_ORION`;

## GitLab working directory

```shell
rm -rf ${HOME}/.jacamar-ci
mkdir <scratch_space>/gitlab-runner
ln -s <scratch_space>/gitlab-runner ${HOME}/.jacamar-ci
chmod 700 <scratch_space>/gitlab-runner
```

`<scratch_space>` per facility
* LLNL: `/usr/workspace/${USER}`
* OLCF: `$MEMBERWORK/csc449`
* ALCF: TBD...
* NERSC: perlmutter: `/pscratch/sd/[FirstLetterOf${USER}]/${USER}`

## SPACK-related issues

```shell
# activate spack
. $SPACK_WORK_DIR/spack/share/spack/setup-env.sh
# if issue is related to a certain environment, then activate it
#   spack env activate $SPACK_ENV_NAME
```

### Cached obsolete packages

Example: `Error: Package 'armpl' not found.`
[#31453](https://github.com/spack/spack/issues/31453)

```shell
spack clean -ab
# or `spack clean -fmps` to keep cached downloads
```

OR expanded set of commands

```shell
spack clean -a
rm -rf $HOME/.spack/cache
spack providers
```

### URL fetch method

Default fetch method is `urllib`, but if there is an issue with downloading
packages, then switch it to `curl`.

```shell
spack config add config:url_fetch_method:curl
spack config add config:connect_timeout:30
```

### Remote package is not accessible

Use pre-downloaded packages. Below is an example for the `python` package.
```shell
mkdir -p pre-stage
# download Python tarball locally
# copy (`scp`) Python tarball into `pre-stage` directory
# refer `pre-stage` directory to `spack`
spack stage -p pre-stage python
```

### LLNL Machines not installing Swift-T

When spack is installing Swift-T, it installs `ant` as a dependency.
For an unknown reason, `ant` is unable to initialize the Java Virtual Machine,
thus we're unable to install Swift-T. For now a [temporary solution](https://github.com/ExaWorks/SDK/blob/9c272ba2462298ff49e91e97f73fca029bd9c11b/.gitlab/llnl-ci-spack.yml#L55-L59) has been put in place.
We chose to instruct Spack to use the available system install of `ant` instead of a Spack installation.

Here is the related issue: [#174](https://github.com/ExaWorks/SDK/issues/174)

The temporary solution can be improved upon once [Spack PR #40976](https://github.com/spack/spack/pull/40976) is merged into Spack

---

## References for GitLab-related services

### LLNL

* [LC Resources and Environment](https://hpc.llnl.gov/documentation/tutorials/livermore-computing-resources-and-environment)
* [LC GitLab CI](https://lc.llnl.gov/confluence/display/GITLAB/GitLab+CI)

### OLCF/ORNL

* [CI/CD Workflows](https://docs.olcf.ornl.gov/services_and_applications/slate/workflows/overview.html)
* [GitLab Runners](https://docs.olcf.ornl.gov/services_and_applications/slate/use_cases/gitlab_runner.html)

### NERSC

* [GitLab](https://docs.nersc.gov/services/gitlab/)
* [NERSC CI docs](https://software.nersc.gov/NERSC/nersc-ci-docs)
* [Introduction to CI at NERSC](https://www.nersc.gov/assets/Uploads/Introduction-to-CI-at-NERSC-07072021.pdf)
* [GitLab CI Tutorial](https://www.nersc.gov/assets/Uploads/2017-02-06-Gitlab-CI.pdf)
* [Advanced GitLab Tutorial](https://www.nersc.gov/assets/Uploads/Advanced-Gitlab.pdf)
* [Spack GitLab Pipeline](https://docs.nersc.gov/applications/e4s/spack_gitlab_pipeline/)
* [CI examples, tutorials, and general resources](https://software.nersc.gov/ci-resources)

---

