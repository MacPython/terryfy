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
}


function port_install_python {
    #major.minor version
    M_dot_m=$1
    Mm=`echo $M_dot_m | tr -d '.'`
    PY="py$Mm"

    sudo port install python$Mm $PY-numpy libpng freetype
    sudo port select --set python python$Mm

    # remove for mpl
    sudo port install $PY-nose $PY-pip  # remove for mpl
}


if [ "$TEST" == "brew_system" ]
then
    brew update

    # use system python, numpy

    sudo easy_install pip
    brew install freetype libpng pkg-config

    sudo pip install nose
    sudo pip install matplotlib

elif [ "$TEST" == "brew_py" ]
then
    brew update

    brew install python

    pip install numpy
    brew install freetype libpng pkg-config

    pip install nose
    pip install matplotlib

elif [ "$TEST" == "brew_py3" ]
then
    brew update

    brew install python3

    pip3 install numpy
    brew install freetype libpng pkg-config

    pip3 install nose
        # pip chokes on auto-installing python-dateutil
        # install it first, an manually
        pip3 -vvv install python-dateutil
    pip3 install matplotlib

elif [ "$TEST" == "macports_py26" ]
then
    PREFIX=/opt/local
    VERSION="2.6"

    install_macports $PREFIX
    port_install_python $VERSION

    sudo pip-2.6 install matplotlib

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
    port_install_python $VERSION

    sudo pip-2.7 install matplotlib

elif [ "$TEST" == "macports_py32" ]
then
    PREFIX=/opt/local
    VERSION="3.2"

    install_macports $PREFIX
    port_install_python $VERSION

    sudo pip-3.2 install matplotlib

elif [ "$TEST" == "macports_py33" ]
then
    PREFIX=/opt/local
    VERSION="3.3"

    install_macports $PREFIX
    port_install_python $VERSION

    # auto install chokes on python-dateutil
    # install from macports instead
    sudo port install py33-dateutil

    sudo pip-3.3 install matplotlib

else
    echo "Unknown test setting ($TEST)"
fi

