Testing utilties for MacOS X on Travis-CI
=========================================

This is a repo designed to be used a submodule for other packages that test and
build python packages on OSX.

There are bash builders for installing Python from python.org_ downloads (with
given version), `macports`_ and `homebrew`_.  Each of these can then be used to
create a virtualenv_ in which to install and test packages.

.. _python.org: http://python.org/download/
.. _Macports: http://www.macports.org
.. _homebrew: http://brew.sh
.. _virtualenv: http://virtualenv.readthedocs.org/en/latest/virtualenv.html
