#!/usr/bin/env sh

if [ "$TEST" == "brew_py" ]
then
    brew update

    brew install python

    pip install nose numpy
    brew install freetype libpng pkg-config

    pip install matplotlib
elif [ "$TEST" == "brew_system" ]
then
    brew update

    # use system python

    pip install nose numpy
    brew install freetype libpng pkg-config

    pip install matplotlib
elif [ "$TEST" == "brew_py3" ]
then
    brew update

    brew install python3

    pip3 install nose numpy
    brew install freetype libpng pkg-config

    pip3 install matplotlib
elif [ "$TEST" == "macports_py26" ]
then
    MACPORTS="MacPorts-2.2.0"
    PREFIX=/opt/local
    M_dot_m="2.6"

    Mm=`echo $M_dot_m | tr -d '.'`
    PY="py$Mm"

    curl https://distfiles.macports.org/MacPorts/$MACPORTS.tar.gz > $MACPORTS.tar.gz --insecure
    tar -xzf $MACPORTS.tar.gz

    cd $MACPORTS
    ./configure --prefix=$PREFIX
    make 
    sudo make install
    cd ..

    export PATH=$PREFIX/bin:$PATH
    sudo port -v selfupdate

    sudo port install python$Mm $PY-nose $PY-pip $PY-numpy libpng freetype
    sudo port select python python$M_dot_m
    sudo port select nosetests nosetests-$M_dot_m

    pip install matplotlib
else
    echo "Unknown test setting ($TEST)"
fi
