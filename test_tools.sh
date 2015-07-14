# Final return code variable used by sub-scripts
RET=0
source test_python_installs.sh
source test_pyver_ge.sh
source test_git_utils.sh
source test_library_installers.sh
# Set the final return code
(exit $RET)
