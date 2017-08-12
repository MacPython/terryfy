Build / test utilities for Python, MacOS X on Travis-CI
=======================================================

This is a repo designed to be used as a submodule for other packages that test
and build python packages on OSX.

There are bash functions to call for installing Python from Python.org_
downloads (with given version), `Macports`_ and `Homebrew`_.  Each of these
can then be used to create a virtualenv_ in which to install and test
packages.

If you only need the Python.org installers (which are a `reasonable default
choice
<https://github.com/MacPython/wiki/wiki/Spinning-wheels#practical-example-of-building-wheels-for-a-project>`_),
then prefer the multibuild_ project, which gets more development attention.

There are also simple bash functions for installing libraries using classic
configure / make / install, or via cmake, and some utilities for working with
waf_

See `matplotlib-wheels <https://github.com/MacPython/matplotlib-wheels>`_ for an
example of using terryfy for a complicated build.

.. _python.org: https://www.python.org/downloads/
.. _Macports: https://www.macports.org
.. _homebrew: http://brew.sh
.. _virtualenv: http://virtualenv.readthedocs.org/en/latest/
.. _waf: https://github.com/waf-project/waf
.. _multibuild: https://github.com/matthew-brett/multibuild
