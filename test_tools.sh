echo "Python on path: `which python`"
echo "Python cmd: $PYTHON_CMD"
$PYTHON_CMD --version

echo "pip on path: `which pip`"
echo "pip cmd: $PIP_CMD"
$PIP_CMD --version

echo "virtualenv on path: `which virtualenv`"
echo "pip cmd: $VIRTUALENV_CMD"

# Return code
RET=0

if [ "$VENV" == "1" ]; then
    if [ "$PYTHON_CMD" != "$PWD/venv/bin/python" ]; then
        echo "Wrong virtualenv python"
        RET = 1
    fi
    if [ "$PIP_CMD" != "$PWD/venv/bin/pip" ]; then
        echo "Wrong virtualenv pip"
        RET=1
    fi
else # not virtualenv
    python_version=`$PYTHON_CMD -c \
        'import sys; print("{}.{}.{}".format(*sys.version_info[:3]))'`
    python_mm=${python_version:0:3}
    python_m=${python_version:0:1}
    if [ $INSTALL_TYPE == "system" ]; then
        if [ "$PYTHON_CMD" != "/usr/bin/python" ]; then
            echo "Wrong system python cmd"
            RET=1
        fi
        if [ "$PIP_CMD" != "sudo /usr/bin/pip" ]; then
            echo "Wrong system pip"
            RET=1
        fi
    elif [ $INSTALL_TYPE == "macpython" ]; then
        if [ "$python_version" != "$VERSION" ]; then
            echo "Wrong macpython python version"
            RET=1
        fi
        if [ "$PYTHON_CMD" != "$MACPYTHON_PREFIX/bin/python$python_mm" ]; then
            echo "Wrong macpython python cmd"
            RET=1
        fi
        if [ "$PIP_CMD" != "sudo $MACPYTHON_PREFIX/bin/pip$python_mm" ]; then
            echo "Wrong macpython pip"
            RET=1
        fi
    elif [ $INSTALL_TYPE == "macports" ]; then
        if [ "$python_mm" != "$VERSION" ]; then
            echo "Wrong macports python version"
            RET=1
        fi
        if [ "$PYTHON_CMD" != "/opt/local/bin/python$python_mm" ]; then
            echo "Wrong macports python cmd"
            RET=1
        fi
        if [ "$PIP_CMD" != "/opt/local/bin/pip$python_mm" ]; then
            echo "Wrong macports pip"
            RET=1
        fi
    elif [ $INSTALL_TYPE == "homebrew" ]; then
        if [ "$python_m" != "$VERSION" ]; then
            echo "Wrong homebrew python version"
            RET=1
        fi
        if [ "$PYTHON_CMD" != "/usr/local/bin/python$python_m" ]; then
            echo "Wrong homebrew python cmd"
            RET=1
        fi
        if [ "$PIP_CMD" != "/usr/local/bin/pip$python_m" ]; then
            echo "Wrong homebrew pip"
            RET=1
        fi
    fi
fi
# Set the return code
(exit $RET)
