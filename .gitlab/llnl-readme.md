# Environment preparation for LLNL machines

(*) [Livermore Computing Resources and Environment](https://hpc.llnl.gov/documentation/tutorials/livermore-computing-resources-and-environment)

Use group directory `/usr/workspace/exaworks`
```bash
mkdir -p sdk/pre-stage; cd sdk
chgrp -R exaworks .
git clone -c feature.manyFiles=true -c core.sharedRepository=true https://github.com/spack/spack.git
chmod -fR 02770 .
```

## 1.a. Spack setup on Quartz
Login to **Quartz** (`ssh <user>@quartz.llnl.gov`) and go to the group directory
```bash
. spack/share/spack/setup-env.sh
# add system compilers to personal `compilers.yaml`
spack compiler find
# install sdk compatible compiler 
spack install --fail-fast gcc@8.1.0%gcc@4.9.3 target=x86_64
# add that compiler to personal `compilers.yaml`
spack compiler add $(spack location -i gcc@8.1.0)
# create and activate a spack env for this micro architecture
spack env create rhel7-broadwell
spack env activate rhel7-broadwell
# use pre-downloaded packages (see Troubleshooting)
#   spack stage -p pre-stage python
# install sdk
spack install --fail-fast exaworks%gcc@8.1.0
```

## 1.b. Spack setup on Lassen
Login to **Lassen** (`ssh <user>@lassen.llnl.gov`) and go to the group directory
```bash
. spack/share/spack/setup-env.sh
spack compiler find
spack install --fail-fast gcc@9.4.0%gcc@4.9.3 target=ppc64le
spack compiler add $(spack location -i gcc@9.4.0)
spack env create rhel7-ppc64le
spack env activate rhel7-ppc64le
# use pre-downloaded packages (see Troubleshooting)
#   spack stage -p pre-stage python
spack install --fail-fast exaworks%gcc@9.4.0
```

## 1.c. Spack setup on Ruby
Login to **Ruby** (`ssh <user>@ruby.llnl.gov`) and go to the group directory
```bash
. spack/share/spack/setup-env.sh
spack compiler find
spack install --fail-fast gcc@8.2.0%gcc@4.9.3
spack compiler add $(spack location -i gcc@8.2.0)
spack env create rhel7-cascadelake
spack env activate rhel7-cascadelake
# use pre-downloaded packages (see Troubleshooting)
#   spack stage -p pre-stage python
spack install --fail-fast exaworks%gcc@8.2.0
```

---

## 2. Final steps
AFTER all spack environments are set then update group permissions:
```bash
chgrp -R exaworks .
chmod -fR 02770 .
```

---

## Troubleshooting

### Issue with downloading Python
Use pre-downloaded packages
```bash
# download Python tarball locally
# copy (`scp`) Python tarball into `pre-stage` directory
# refer `pre-stage` directory to `spack`
spack stage -p pre-stage python
```

---
