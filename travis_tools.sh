#!/bin/bash
# Use with ``source travis_tools.sh``

GET_PIP_URL=https://bootstrap.pypa.io/get-pip.py
MACPYTHON_PREFIX=/Library/Frameworks/Python.framework/Versions
PYTHON_URL=https://www.python.org/ftp/python
MACPORTS_URL=https://distfiles.macports.org/MacPorts
MACPORTS_VERSION="MacPorts-2.2.1"
MACPORTS_PREFIX=/opt/local
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
    if [ -z "$PYTHON_CMD" ]; then
        echo "PYTHON_CMD variable not defined"
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


function get_py_digit {
    check_python
    $PYTHON_CMD -c "import sys; print(sys.version_info[0])"
}


function get_py_mm {
    check_python
    $PYTHON_CMD -c "import sys; print('{0}.{1}'.format(*sys.version_info[0:2]))"
}


function get_py_mm_nodot {
    check_python
    $PYTHON_CMD -c "import sys; print('{0}{1}'.format(*sys.version_info[0:2]))"
}


function get_py_prefix {
    check_python
    $PYTHON_CMD -c "import sys; print(sys.prefix)"
}


function install_macpython {
    # Installs Python.org Python
    # puts bin directory on the PATH
    # sets $PYTHON_CMD variable to python executable
    local py_version=$1
    local py_dmg=python-$py_version-macosx10.6.dmg
    local dmg_path=$DOWNLOADS_SDIR/$py_dmg
    mkdir -p $DOWNLOADS_SDIR
    curl $PYTHON_URL/$py_version/${py_dmg} > $dmg_path
    require_success "Failed to download mac python $py_version"
    hdiutil attach $dmg_path -mountpoint /Volumes/Python
    sudo installer -pkg /Volumes/Python/Python.mpkg -target /
    require_success "Failed to install Python.org Python $py_version"
    local py_mm=${py_version:0:3}
    PYTHON_CMD=$MACPYTHON_PREFIX/$py_mm/bin/python$py_mm
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
    # major.minor version
    local py_version=$1
    local force=$2
    if [ "$force" == "1" ]; then
        force="-f"
    fi
    local py_mm=${py_version:0:3}
    local py_mm_nodot=`echo $py_mm | tr -d '.'`
    sudo port install $force python$py_mm_nodot
    require_success "Failed to install macports python"
    PYTHON_CMD=$MACPORTS_PREFIX/bin/python$py_mm
}


function macports_install_pip {
    local py_mm=`get_py_mm`
    local py_mm_nodot=`get_py_mm_nodot`
    sudo port install py$py_ver_spec-pip
    PIP_CMD="sudo $MACPORTS_PREFIX/pip-$py_mm"
}


function macports_install_virtualenv {
    local py_mm=`get_py_mm`
    local py_mm_nodot=`get_py_mm_nodot`
    sudo port install py$py_mm_nodot-virtualenv
    VIRTUALENV_CMD="$MACPORTS_PREFIX/bin/virtualenv-$py_mm"
}


function brew_install_python {
    # Only installs by version 2 or 3
    local py_version=$1
    local py_digit=${py_version:0:1}
    if [[ "$py_digit" == "3" ]] ; then
        brew install python3
    else
        brew install python2
    fi
    require_success "Failed to install python"
    PYTHON_CMD=/usr/local/bin/python$py_digit
}


function brew_install_pip {
    # already installed apparently
    local py_digit=`get_py_digit`
    PIP_CMD=/usr/local/bin/pip${py_digit}
}


function system_install_pip {
    local py_digit=`get_py_digit`
    PIP_CMD=/usr/local/bin/pip${py_digit}
}


function install_pip {
    check_python
    mkdir -p $DOWNLOADS_SDIR
    curl $GET_PIP_URL > $DOWNLOADS_SDIR/get-pip.py
    require_success "failed to download get-pip"
    sudo $PYTHON_CMD $DOWNLOADS_SDIR/get-pip.py
    require_success "Failed to install pip"
    local py_prefix=`get_py_prefix`
    local py_mm=`get_py_mm`
    PIP_CMD="sudo $py_prefix/bin/pip$py_mm"
}


function install_virtualenv {
    # Install virtualenv
    check_pip
    $PIP_CMD install virtualenv
    require_success "Failed to install virtualenv"
    check_python
    VIRTUALENV_CMD="`dirname $PYTHON_CMD`/virtualenv"
}


function make_workon_venv {
    local venv_dir=$1
    if [ -z "$venv_dir" ]; then
        venv_dir="venv"
    fi
    venv_dir=`abspath $venv_dir`
    check_python
    $VIRTUALENV_CMD --python=$PYTHON_CMD $venv_dir
    PYTHON_CMD=$venv_dir/bin/python
    PIP_CMD=$venv_dir/bin/pip
}


function get_python_environment {
    local install_type=$1
    local version=$2
    local venv_flag=$3
    case $install_type in
    "macpython")
        install_macpython $version
        install_pip
        if [ -n "$venv_flag" ]; then
            install_virtualenv
            make_workon_venv
        fi
        ;;
    "macports")
        install_macports
        macports_install_python $version
        if [ -n "$venv_flag" ]; then
            macports_install_virtualenv
            make_workon_venv
        fi
        ;;
    "homebrew")
        # Already installed on travis worker
        brew update
        brew_install_python $version
        install_pip
        if [ -n "$venv_flag" ]; then
            install_virtualenv
            make_workon_venv
        fi
        ;;
    "system")
        PYTHON_CMD="/usr/bin/python"
        sudo easy_install pip
        PIP_CMD="sudo /usr/bin/pip"
        if [ -n "$venv_flag" ]; then
            install_virtualenv
            make_workon_venv
        fi
        ;;
    *)
        echo "Strange install type $install_type"
        exit 1
        ;;
    esac
    # Put python binary on path
    PATH="`dirname $PYTHON_CMD`:$PATH"
}
