#!/usr/bin/env sh

if [ "$TEST" == "brew_py" ]
then
    brew update

    brew install python

    pip install numpy
#    brew install freetype libpng pkg-config
#    pip install matplotlib
elif [ "$TEST" == "brew_sys" ]
then
    brew update

    # use system python

    pip install numpy
#    brew install freetype libpng pkg-config
#    pip install matplotlib
elif [ "$TEST" == "brew_py3" ]
then
    brew update

    brew install python3

    pip3 install numpy
#    brew install freetype libpng pkg-config
#    pip install matplotlib
else
    echo "Unknown test setting ($TEST)"
fi
