# Final return code variable used by sub-scripts
RET=0
# ``source travis_utils.sh`` required before these commands
# Allow errors during tests
set +e
source test_python_installs.sh
echo "RET is $RET"
source test_pyver_ge.sh
echo "RET is $RET"
source test_git_utils.sh
echo "RET is $RET"
source test_library_installers.sh
echo "RET is $RET"
source test_osx_versions.sh
# Set the final return code
(exit $RET)
