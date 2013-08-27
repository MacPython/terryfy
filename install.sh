#!/usr/bin/env sh


function install_macports {
    PREFIX=$1
    MACPORTS="MacPorts-2.2.0"
    curl https://distfiles.macports.org/MacPorts/$MACPORTS.tar.gz > $MACPORTS.tar.gz --insecure
    tar -xzf $MACPORTS.tar.gz

    cd $MACPORTS
    ./configure --prefix=$PREFIX
    make 
    sudo make install
    cd ..

    export PATH=$PREFIX/bin:$PATH
    sudo port -v selfupdate
    sudo port install pkgconfig libpng freetype
    require_success "Failed to install matplotlib dependencies"
}


function port_install_python {
    #major.minor version
    M_dot_m=$1
    Mm=`echo $M_dot_m | tr -d '.'`
    PY="py$Mm"

    FORCE=""
    if [ -z "$2" ]; then
        echo ""
    elif [ "$2" == "force" ]; then
        FORCE="-f"
    fi

    sudo port install $FORCE python$Mm
    require_success "Failed to install python"

    sudo port install $PY-numpy libpng freetype
    require_success "Failed to install matplotlib dependencies"
    sudo port select --set python python$Mm

    # remove for mpl
    sudo port install $PY-nose $PY-pip  # remove for mpl

    export PIP="sudo pip-$M_dot_m"
    export NOSETESTS=/opt/local/bin/nosetests-$M_dot_m
}


function install_tkl_85 {
    TCL_VERSION="8.5.14.0"
    curl http://downloads.activestate.com/ActiveTcl/releases/$TCL_VERSION/ActiveTcl$TCL_VERSION.296777-macosx10.5-i386-x86_64-threaded.dmg > ActiveTCL.dmg
    hdiutil attach ActiveTCL.dmg -mountpoint /Volumes/ActiveTcl
    sudo installer -pkg /Volumes/ActiveTcl/ActiveTcl-8.5.pkg -target /
    require_success "Failed to install ActiveTcl $TCL_VERSION"
}


function install_mac_python {
    PY_VERSION=$1
    curl http://python.org/ftp/python/$PY_VERSION/python-$PY_VERSION-macosx10.6.dmg > python-$PY_VERSION.dmg
    hdiutil attach python-$PY_VERSION.dmg -mountpoint /Volumes/Python
    sudo installer -pkg /Volumes/Python/Python.mpkg -target /
    require_success "Failed to install Python.org Python $PY_VERSION" 
}


function install_freetype {
    FT_VERSION=$1
    curl -L http://sourceforge.net/projects/freetype/files/freetype2/2.5.0/freetype-2.5.0.1.tar.bz2/download > freetype.tar.bz2
    tar -xjf freetype.tar.bz2
    cd freetype-$FT_VERSION
    ./configure --enable-shared=no --enable-static=true
    make
    sudo make install
    require_success "Failed to install freetype $FT_VERSION" 
    cd ..
}


function require_success {
    STATUS=$?
    MESSAGE=$1
    if [ "$STATUS" != "0" ]; then
        echo $MESSAGE
        exit $STATUS
    fi
}


function install_libpng {
    VERSION=$1
    curl -L http://downloads.sourceforge.net/project/libpng/libpng16/$VERSION/libpng-$VERSION.tar.gz > libpng.tar.gz
    tar -xzf libpng.tar.gz
    cd libpng-$VERSION
    ./configure --enable-shared=no --enable-static=true
    make
    sudo make install
    require_success "Failed to install libpng $VERSION"
    cd ..
}


function install_xquartz {
    VERSION=$1
    curl http://xquartz.macosforge.org/downloads/SL/XQuartz-$VERSION.dmg > xquartz.dmg
    hdiutil attach xquartz.dmg -mountpoint /Volumes/XQuartz
    sudo installer -pkg /Volumes/XQuartz/XQuartz.pkg -target /
    require_success "Failed to install XQuartz $VERSION"
}


if [ "$TEST" == "brew_system" ]
then
    brew update

    # use system python, numpy

    sudo easy_install pip
    brew install freetype libpng pkg-config

    sudo pip install nose
    sudo pip install matplotlib
    require_success "Failed to install matplotlib"

    export NOSETESTS=nosetests

elif [ "$TEST" == "brew_py" ]
then
    brew update

    brew install python
    require_success "Failed to install python"

    brew install freetype libpng pkg-config
    require_success "Failed to install matplotlib dependencies"

    PIP=pip
    $PIP install numpy
    $PIP install nose
    $PIP install matplotlib
    require_success "Failed to install matplotlib"

    export NOSETESTS=nosetests

elif [ "$TEST" == "brew_py3" ]
then
    brew update

    brew install python3
    require_success "Failed to install python"

    brew install freetype libpng pkg-config
    require_success "Failed to install matplotlib dependencies"

    PIP=pip3
    $PIP install numpy
    $PIP install nose
        # pip chokes on auto-installing python-dateutil
        # install it first, an manually
        $PIP -vvv install python-dateutil
    $PIP install matplotlib
    require_success "Failed to install matplotlib"

    export NOSETESTS=nosetests

elif [ "$TEST" == "macports_py26" ]
then
    PREFIX=/opt/local
    VERSION="2.6"

    install_macports $PREFIX
    port_install_python $VERSION

    $PIP install matplotlib
    require_success "Failed to install matplotlib"

elif [ "$TEST" == "macports_py27" ]
then
    PREFIX=/opt/local
    VERSION="2.7"

        # debug
        # trouble activating python27, what is in macports?
        echo "what is in /Applications?"
        sudo ls /Applications

        which port
        sudo which port

        sudo mkdir -p $PREFIX
        echo "what is in $PREFIX"
        sudo ls $PREFIX/*

    install_macports $PREFIX
    port_install_python $VERSION force

    $PIP install matplotlib
    require_success "Failed to install matplotlib"

elif [ "$TEST" == "macports_py32" ]
then
    PREFIX=/opt/local
    VERSION="3.2"

    install_macports $PREFIX
    port_install_python $VERSION

    $PIP install matplotlib
    require_success "Failed to install matplotlib"

elif [ "$TEST" == "macports_py33" ]
then
    PREFIX=/opt/local
    VERSION="3.3"

    install_macports $PREFIX
    port_install_python $VERSION

    # auto install chokes on python-dateutil
    # install from macports instead
    sudo port install py33-dateutil

    $PIP install matplotlib

elif [ "$TEST" == "macpython27_10.8" ]
then
    PY_VERSION="2.7.5"
    FT_VERSION="2.5.0.1"
    PNG_VERSION="1.6.3"
    XQUARTZ_VERSION="2.7.4"
    install_mac_python $PY_VERSION
    install_tkl_85
    install_libpng $PNG_VERSION
    install_freetype $FT_VERSION

    which python
    curl https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py > ez_setup.py
    sudo python ez_setup.py

    sudo easy_install pip
    which pip
    which pip-2.7
    sudo pip install numpy
    sudo pip install nose
    sudo pip install matplotlib
    require_success "Failed to install matplotlib"

    export NOSETESTS=nosetests-2.7

elif [ "$TEST" == "macpython33_10.8" ]
then
    PY_VERSION="3.3.2"
    FT_VERSION="2.5.0.1"
    PNG_VERSION="1.6.3"
    XQUARTZ_VERSION="2.7.4"
    install_mac_python $PY_VERSION
    install_tkl_85
    install_libpng $PNG_VERSION
    install_freetype $FT_VERSION

    curl https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py > ez_setup.py
    sudo python3 ez_setup.py

    which easy_install
    sudo easy_install pip
    which pip
    which pip3
    which pip-3.3
    which pip3.3
    sudo pip install numpy
    sudo pip install nose
    sudo pip install matplotlib
    require_success "Failed to install matplotlib"

    export NOSETESTS=nosetests

else
    echo "Unknown test setting ($TEST)"
fi
