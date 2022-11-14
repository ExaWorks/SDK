# Environment preparation for LLNL machines

(*) [LC Resources and Environment](https://hpc.llnl.gov/documentation/tutorials/livermore-computing-resources-and-environment),
 [LC GitLab CI](https://lc.llnl.gov/confluence/display/GITLAB/GitLab+CI)

All necessary processes are automated and integrated into CI, but for manual 
preparation the following steps could be taken.

---

Use group directory `/usr/workspace/exaworks`
```bash
newgrp exaworks
chgrp -fR exaworks .
mkdir -p sdk; cd sdk
git clone -c feature.manyFiles=true -c core.sharedRepository=true https://github.com/spack/spack.git
chmod -fR 02770 .
```

## 1.a. Spack setup on Quartz
Login to **Quartz** (`ssh <user>@quartz.llnl.gov`) and go to the group directory
```bash
. spack/share/spack/setup-env.sh
# create and activate a spack env for this micro architecture
spack env create rhel7-broadwell
spack env activate rhel7-broadwell
spack compiler find
# install sdk compatible compiler 
spack install --fail-fast gcc@8.1.0 ^python@3.9 %gcc@4.9.3 target=x86_64
spack compiler add $(spack location -i gcc@8.1.0)
# use pre-downloaded packages (see Troubleshooting)
#   spack stage -p pre-stage python
# install exaworks-packages
spack install --fail-fast exaworks%gcc@8.1.0
```

## 1.b. Spack setup on Lassen
Login to **Lassen** (`ssh <user>@lassen.llnl.gov`) and go to the group directory
```bash
. spack/share/spack/setup-env.sh
spack env create rhel7-ppc64le
spack env activate rhel7-ppc64le
spack compiler find
spack install --fail-fast gcc@9.4.0 ^python@3.9 %gcc@4.9.3 target=ppc64le
spack compiler add $(spack location -i gcc@9.4.0)
# use pre-downloaded packages (see Troubleshooting)
#   spack stage -p pre-stage python
spack install --fail-fast exaworks%gcc@9.4.0
```

## 1.c. Spack setup on Ruby
Login to **Ruby** (`ssh <user>@ruby.llnl.gov`) and go to the group directory
```bash
. spack/share/spack/setup-env.sh
spack env create rhel7-cascadelake
spack env activate rhel7-cascadelake
spack compiler find
spack install --fail-fast gcc@8.2.0 ^python@3.9 %gcc@4.9.3
spack compiler add $(spack location -i gcc@8.2.0)
# use pre-downloaded packages (see Troubleshooting)
#   spack stage -p pre-stage python
spack install --fail-fast exaworks%gcc@8.2.0
```

---

## 2. Final steps
AFTER all spack environments are set then update group permissions:
```bash
# newgrp exaworks
chgrp -fR exaworks .
chmod -fR 02770 .
```

---

## Troubleshooting

### Issue with downloading Python
Use pre-downloaded packages
```bash
mkdir -p pre-stage
# download Python tarball locally
# copy (`scp`) Python tarball into `pre-stage` directory
# refer `pre-stage` directory to `spack`
spack stage -p pre-stage python
```

### Issue with cached obsolete packages
`Error: Package 'armpl' not found.` [#31453](https://github.com/spack/spack/issues/31453)
```bash
spack clean -ab
# or `spack clean -fmps` to keep cached downloads
```

---
