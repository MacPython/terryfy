.. image:: https://travis-ci.org/mrterry/mpl_on_travis_mac.png
   :target: https://travis-ci.org/mrterry/mpl_on_travis_mac

Testing Matplotlib on MacOS X on Travis-CI
==========================================

This is an attempt to get continuous integration working for:
matplotlib,
on Travis CI,
on MacOS X.

Travis-CI 
`Mac environment <http://about.travis-ci.org/docs/user/osx-ci-environment/>`_
uses Mac OS X 10.8.2

It targets:

    - system python (2.7) and numpy
    - brew python 2.7 / PyPI numpy
    - brew python 3.3 / PyPI numpy
    - macports python 2.6, numpy
    - macports python 2.7, numpy
    - macports python 3.2, numpy
    - macports python 3.3, numpy

Eventually, this will try to get all the backends installed.
