#!/bin/bash
# Use with ``source travis_tools.sh``

MACPYTHON_URL=https://www.python.org/ftp/python
MACPYTHON_PY_PREFIX=/Library/Frameworks/Python.framework/Versions
GET_PIP_URL=https://bootstrap.pypa.io/get-pip.py
MACPORTS_URL=https://distfiles.macports.org/MacPorts
MACPORTS_VERSION="MacPorts-2.2.1"
MACPORTS_PREFIX=/opt/local
MACPORTS_PY_PREFIX=$MACPORTS_PREFIX$MACPYTHON_PY_PREFIX
NIPY_WHEELHOUSE=https://nipy.bic.berkeley.edu/scipy_installers
DOWNLOADS_SDIR=downloads
WORKING_SDIR=working


function require_success {
    STATUS=$?
    MESSAGE=$1
    if [ "$STATUS" != "0" ]; then
        echo $MESSAGE
        exit $STATUS
    fi
}


function check_python {
    if [ -z "$PYTHON_EXE" ]; then
        echo "PYTHON_EXE variable not defined"
        exit 1
    fi
}


function check_pip {
    if [ -z "$PIP_CMD" ]; then
        echo "PIP_CMD variable not defined"
        exit 1
    fi
}


function abspath {
    python -c "import os; print(os.path.abspath('$1'))"
}


function realpath {
    python -c "import os; print(os.path.realpath('$1'))"
}


function get_py_digit {
    check_python
    $PYTHON_EXE -c "import sys; print(sys.version_info[0])"
}


function get_py_mm {
    check_python
    $PYTHON_EXE -c "import sys; print('{0}.{1}'.format(*sys.version_info[0:2]))"
}


function get_py_mm_nodot {
    check_python
    $PYTHON_EXE -c "import sys; print('{0}{1}'.format(*sys.version_info[0:2]))"
}


function get_py_prefix {
    check_python
    $PYTHON_EXE -c "import sys; print(sys.prefix)"
}


function get_py_site_packages {
    # Return site-packages directory using PYTHON_EXE
    check_python
    $PYTHON_EXE -c "from distutils import sysconfig; print(sysconfig.get_python_lib())"
}


function toggle_py_sys_site_packages {
    # When in virtualenv (not checked) toggle use of system site packages
    local no_sp_fname="`get_py_site_packages`/../no-global-site-packages.txt"
    if [ -f "$no_sp_fname" ]; then
        rm $no_sp_fname
    else
        touch $no_sp_fname
    fi
}


function get_pip_sudo {
    # Echo "sudo" if PIP_CMD starts with sudo
    # Useful for checking if Python installations need sudo
    check_pip
    if [ "${PIP_CMD:0:4}" == "sudo" ]; then
        echo "sudo"
    fi
}


function install_macpython {
    # Installs Python.org Python
    # Parameter $version
    # Version given in major.minor.micro e.g  "3.4.1"
    # sets $PYTHON_EXE variable to python executable
    local py_version=$1
    local py_dmg=python-$py_version-macosx10.6.dmg
    local dmg_path=$DOWNLOADS_SDIR/$py_dmg
    mkdir -p $DOWNLOADS_SDIR
    curl $MACPYTHON_URL/$py_version/${py_dmg} > $dmg_path
    require_success "Failed to download mac python $py_version"
    hdiutil attach $dmg_path -mountpoint /Volumes/Python
    sudo installer -pkg /Volumes/Python/Python.mpkg -target /
    require_success "Failed to install Python.org Python $py_version"
    local py_mm=${py_version:0:3}
    PYTHON_EXE=$MACPYTHON_PY_PREFIX/$py_mm/bin/python$py_mm
}


function install_pip {
    # Generic install pip
    # Gets needed version from version implied by $PYTHON_EXE
    # Installs pip into python given by $PYTHON_EXE
    # Assumes pip will be installed into same directory as $PYTHON_EXE
    check_python
    mkdir -p $DOWNLOADS_SDIR
    curl $GET_PIP_URL > $DOWNLOADS_SDIR/get-pip.py
    require_success "failed to download get-pip"
    sudo $PYTHON_EXE $DOWNLOADS_SDIR/get-pip.py
    require_success "Failed to install pip"
    local py_mm=`get_py_mm`
    PIP_CMD="sudo `dirname $PYTHON_EXE`/pip$py_mm"
}


function install_virtualenv {
    # Generic install of virtualenv
    # Installs virtualenv into python given by $PYTHON_EXE
    # Assumes virtualenv will be installed into same directory as $PYTHON_EXE
    check_pip
    $PIP_CMD install virtualenv
    require_success "Failed to install virtualenv"
    check_python
    VIRTUALENV_CMD="`dirname $PYTHON_EXE`/virtualenv"
}


function make_workon_venv {
    # Make a virtualenv in given directory ('venv' default)
    # Set $PYTHON_EXE, $PIP_CMD to virtualenv versions
    # Parameter $venv_dir
    #    directory for virtualenv
    local venv_dir=$1
    if [ -z "$venv_dir" ]; then
        venv_dir="venv"
    fi
    venv_dir=`abspath $venv_dir`
    check_python
    $VIRTUALENV_CMD --python=$PYTHON_EXE $venv_dir
    PYTHON_EXE=$venv_dir/bin/python
    PIP_CMD=$venv_dir/bin/pip
}


function install_macports {
    # Initialize macports, put macports on PATH
    local macports_path=$DOWNLOADS_SDIR/$MACPORTS_VERSION.tar.gz
    mkdir -p $DOWNLOADS_SDIR
    curl $MACPORTS_URL/$MACPORTS_VERSION.tar.gz > $macports_path --insecure
    require_success "failed to download macports"
    mkdir -p $WORKING_SDIR
    cd $WORKING_SDIR
    tar -xzf ../$macports_path
    cd $MACPORTS_VERSION
    ./configure --prefix=$MACPORTS_PREFIX
    make
    sudo make install
    cd ../..
    PATH=$MACPORTS_PREFIX/bin:$PATH
    sudo port -v selfupdate
}


function macports_install_python {
    # Installs macports python
    # Parameter $version
    # Version given in format major.minor e.g. "3.4"
    # sets $PYTHON_EXE variable to python executable
    local py_version=$1
    local force=$2
    if [ "$force" == "1" ]; then
        force="-f"
    fi
    local py_mm=${py_version:0:3}
    local py_mm_nodot=`echo $py_mm | tr -d '.'`
    sudo port install $force python$py_mm_nodot
    require_success "Failed to install macports python"
    PYTHON_EXE=`realpath $MACPORTS_PREFIX/bin/python$py_mm`
}


function macports_install_pip {
    # macports install of pip
    # Gets needed version from version implied by $PYTHON_EXE
    local py_mm=`get_py_mm`
    local py_mm_nodot=`get_py_mm_nodot`
    sudo port install py$py_mm_nodot-pip
    PIP_CMD="sudo $MACPORTS_PREFIX/bin/pip-$py_mm"
}


function macports_install_virtualenv {
    # macports install of virtualenv
    # Gets needed version from version implied by $PYTHON_EXE
    local py_mm=`get_py_mm`
    local py_mm_nodot=`get_py_mm_nodot`
    sudo port install py$py_mm_nodot-virtualenv
    VIRTUALENV_CMD="$MACPORTS_PREFIX/bin/virtualenv-$py_mm"
}


function brew_install_python {
    # Installs macports python
    # Parameter $version
    # Version can only be "2" or "3"
    # sets $PYTHON_EXE variable to python executable
    local py_version=$1
    local py_digit=${py_version:0:1}
    if [[ "$py_digit" == "3" ]] ; then
        brew install python3
    else
        brew install python
    fi
    require_success "Failed to install python"
    PYTHON_EXE=/usr/local/bin/python$py_digit
}


function brew_set_pip_cmd {
    # homebrew set of $PIP_CMD variable
    # pip already installed by Python formula
    # Gets version from version implied by $PYTHON_EXE
    # https://github.com/Homebrew/homebrew/wiki/Homebrew-and-Python
    local py_digit=`get_py_digit`
    PIP_CMD=/usr/local/bin/pip${py_digit}
}


function patch_sys_python {
    # Fixes error discussed here:
    # http://stackoverflow.com/questions/22313407/clang-error-unknown-argument-mno-fused-madd-python-package-installation-fa
    # Present for OSX 10.9.2 fixed in 10.9.3
    # This should be benign for 10.9.3 though
    local py_sys_dir="/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7"
    pushd $py_sys_dir
    if [ -n "`grep fused-madd _sysconfigdata.py`" ]; then
        sudo sed -i '.old' 's/ -m\(no-\)\{0,1\}fused-madd//g' _sysconfigdata.py
        sudo rm _sysconfigdata.pyo _sysconfigdata.pyc
    fi
    popd
}


function system_install_pip {
    # Install pip into system python
    sudo easy_install pip
    PIP_CMD="sudo /usr/local/bin/pip"
}


function system_install_virtualenv {
    # Install virtualenv into system python
    # Needs $PIP_CMD
    check_pip
    $PIP_CMD install virtualenv
    require_success "Failed to install virtualenv"
    VIRTUALENV_CMD="/usr/local/bin/virtualenv"
}


function get_python_environment {
    # Set up python environment
    # Parameters:
    #     $install_type : {macpython|macports|homebrew|system}
    #         Type of Python to install
    #     $version :
    #         macpython : major.minor.micro e.g. "3.4.1"
    #         macpports : major.minor e.g. "3.4"
    #         homebrew : major e.g "3"
    #         system : ignored (but required to be not empty)
    #     $venv_dir : {directory_name|not defined}
    #         If defined - make virtualenv in this directory, set python / pip
    #         commands accordingly
    #
    # Installs Python
    # Sets $PYTHON_EXE to path to Python executable
    # Sets $PIP_CMD to full command for pip (including sudo if necessary)
    # If $venv_dir defined, Sets $VIRTUALENV_CMD to virtualenv executable
    # Puts directory of $PYTHON_EXE on $PATH
    local install_type=$1
    local version=$2
    local venv_dir=$3
    case $install_type in
    macpython)
        install_macpython $version
        install_pip
        if [ -n "$venv_dir" ]; then
            install_virtualenv
            make_workon_venv $venv_dir
        fi
        ;;
    macports)
        install_macports
        macports_install_python $version
        macports_install_pip
        if [ -n "$venv_dir" ]; then
            macports_install_virtualenv
            make_workon_venv $venv_dir
        fi
        ;;
    homebrew)
        # Homebrew already installed on travis worker
        brew update
        brew_install_python $version
        brew_set_pip_cmd
        if [ -n "$venv_dir" ]; then
            install_virtualenv
            make_workon_venv $venv_dir
        fi
        ;;
    system)
        PYTHON_EXE="/usr/bin/python"
        system_install_pip
        if [ -n "$venv_dir" ]; then
            system_install_virtualenv
            make_workon_venv $venv_dir
        fi
        ;;
    *)
        echo "Strange install type $install_type"
        exit 1
        ;;
    esac
    # Put python binary on path and export
    export PATH="`dirname $PYTHON_EXE`:$PATH"
    export PYTHON_EXE PIP_CMD
}
