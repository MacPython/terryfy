.. image:: https://travis-ci.org/mrterry/mpl_on_travis_mac.png
   :target: https://travis-ci.org/mrterry/mpl_on_travis_mac

Testing Matplotlib on MacOS X on Travis-CI
==========================================

This repo will facilitate build and test matplotlib, on MacOS X for a wide range of
installation methods and Python versions.  The repo tests on Mac OS 10.8 as
provided by the Travis-CI 
`Mac environment <http://about.travis-ci.org/docs/user/osx-ci-environment/>`_
Mac OS X testing environment.

Unless denoted otherwise, python dependencies are auto-installed by pip.  

Testing matrix:

+---------------+----------------+--------------+----------------+------------------------+-----------------+----------------------------+
| Python Source | Python Version | libpng       | freetype       | numpy                  | dateutil [#du]_ | virtual environment [#ve]_ |
+---------------+----------------+--------------+----------------+------------------------+-----------------+----------------------------+
| `python.org`_ | 2.7.5          | 1.6.2 source | 2.5.0.1 source | 1.7.1 binary installer |                 | No                         |
+---------------+----------------+--------------+----------------+------------------------+-----------------+----------------------------+
| `python.org`_ | 2.7            | 1.6.2 source | 2.5.0.1 source | pip PyPI               |                 | No                         |
+---------------+----------------+--------------+----------------+------------------------+-----------------+----------------------------+
| `python.org`_ | 3.3.2          | 1.6.2 source | 2.5.0.1 source | pip PyPI               | 2.0             | No                         |
+---------------+----------------+--------------+----------------+------------------------+-----------------+----------------------------+
| system        | 2.7            | brew         | brew           | pip PyPI               |                 | No                         |
+---------------+----------------+--------------+----------------+------------------------+-----------------+----------------------------+
| system        | 2.7            | brew         | brew           | pip PyPI               |                 | virtualenv                 |
+---------------+----------------+--------------+----------------+------------------------+-----------------+----------------------------+
| brew_         | 2.7            | brew         | brew           | brew                   |                 | No                         |
+---------------+----------------+--------------+----------------+------------------------+-----------------+----------------------------+
| brew_         | 2.7            | brew         | brew           | brew                   |                 | virtualenv                 |
+---------------+----------------+--------------+----------------+------------------------+-----------------+----------------------------+
| brew_         | 3.3            | brew         | brew           | brew                   | 2.0             | No                         |
+---------------+----------------+--------------+----------------+------------------------+-----------------+----------------------------+
| brew_         | 3.3            | brew         | brew           | brew                   | 2.0             | virtualenv                 |
+---------------+----------------+--------------+----------------+------------------------+-----------------+----------------------------+
| Macports_     | 2.6            | Macports     | Macports       | Macports               |                 | No                         |
+---------------+----------------+--------------+----------------+------------------------+-----------------+----------------------------+
| Macports_     | 2.6            | Macports     | Macports       | Macports               |                 | virtualenv                 |
+---------------+----------------+--------------+----------------+------------------------+-----------------+----------------------------+
| Macports_     | 2.7            | Macports     | Macports       | Macports               |                 | No                         |
+---------------+----------------+--------------+----------------+------------------------+-----------------+----------------------------+
| Macports_     | 2.7            | Macports     | Macports       | Macports               |                 | virtualenv                 |
+---------------+----------------+--------------+----------------+------------------------+-----------------+----------------------------+
| Macports_     | 3.2            | Macports     | Macports       | Macports               |                 | No                         |
+---------------+----------------+--------------+----------------+------------------------+-----------------+----------------------------+
| Macports_     | 3.2            | Macports     | Macports       | Macports               |                 | virtualenv                 |
+---------------+----------------+--------------+----------------+------------------------+-----------------+----------------------------+
| Macports_     | 3.3            | Macports     | Macports       | Macports               | 2.0             | No                         |
+---------------+----------------+--------------+----------------+------------------------+-----------------+----------------------------+
| Macports_     | 3.3            | Macports     | Macports       | Macports               | 2.0             | virtualenv                 |
+---------------+----------------+--------------+----------------+------------------------+-----------------+----------------------------+

.. _python.org: http://python.org/download/
.. _brew: brew.sh
.. _Macports: www.macports.org

.. [#du]: The latest python-dateutil (2.1) fails to install on Python 3.3.  

.. [#ve]: "virtualenv" identifies the classic virtual environment library
   available to Python 2 and beyond.  "pyvenv" identifies the virtual
   environment library included in the standard library starting with Python
   3.3. 

At present, we install a minimal set of backends.  Backend testing coverate
will expand as the repo matures.
