# Check library installer routines

# Re-create testing directory
rm -rf library-testing
mkdir library-testing

# terryfy directory location
source library_installers.sh
terryfy_pwd=$PWD
if [[ $TERRYFY_DIR != $terryfy_pwd ]]; then
    echo "TERRYFY_DIR != $terryfy_pwd"
    RET=1
fi

# Still correct after changing directory?
cd library-testing
# terryfy directory location
source ../library_installers.sh
if [[ $TERRYFY_DIR != $terryfy_pwd ]]; then
    echo "TERRYFY_DIR != $terryfy_pwd"
    RET=1
fi

# Clean up after
cd ..
rm -rf library-testing
