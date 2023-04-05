# Troubleshooting

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

---

## References for GitLab-related services

### LLNL

* [LC Resources and Environment](https://hpc.llnl.gov/documentation/tutorials/livermore-computing-resources-and-environment)
* [LC GitLab CI](https://lc.llnl.gov/confluence/display/GITLAB/GitLab+CI)

### OLCF/ORNL

* [CI/CD Workflows](https://docs.olcf.ornl.gov/services_and_applications/slate/workflows/overview.html)
* [GitLab Runners](https://docs.olcf.ornl.gov/services_and_applications/slate/use_cases/gitlab_runner.html)

---

