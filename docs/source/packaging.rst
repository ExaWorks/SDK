.. _chapter_packaging:

=========
Packaging
=========

Spack
-----

Spack package creation tutorial: https://spack-tutorial.readthedocs.io/en/latest/tutorial_packaging.html

Highlighted steps of the package creation

1. Spack installation ::

    git clone https://github.com/spack/spack.git
    . spack/share/spack/setup-env.sh

2. Create Spack package recipe by the template ::

    # spack create <path-to-tarball>
    spack create https://github.com/radical-cybertools/radical.pilot/archive/refs/tags/v1.8.0.tar.gz
    # package template will be created here (all python packages starts with "py-"):
    #   <path-to-spack>/spack/var/spack/repos/builtin/packages/py-radical-pilot/package.py

3. Notes for recipe editing

   a) If package dependencies are not in Spack, they should be added as well;
   b) Variable ``maintainers`` is a list of GitHub usernames, who are
      responsible to maintain a corresponding Spack package (they should
      consented to be maintainers);
   c) Function call ``version('develop', branch='devel')`` maps Spack package
      version ``develop`` to the corresponding GitHub branch (GitHub URL of the
      project should be set with ``git`` variable);
   d) Function call ``depends_on`` lists hard requirements, not soft
      preferences;
   e) Not supported version of the package should be described with
      ``deprecated=True`` set and shouldn't be removed from the recipe;

4. Submit created package recipe

   a) Fork Spack GitHub repository (https://github.com/spack/spack.git);
   b) Submit created package back to Spack as a Pull Request;

Spack packages list: https://spack.readthedocs.io/en/latest/package_list.html