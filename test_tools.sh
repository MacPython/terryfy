# Return code
RET=0

echo "Python on path: `which python`"
echo "Python cmd: $PYTHON_CMD"
$PYTHON_CMD --version
if [ $? -ne 0 ] ; then RET=1; fi

echo "pip on path: `which pip`"
echo "pip cmd: $PIP_CMD"
$PIP_CMD --version
if [ $? -ne 0 ] ; then RET=1; fi

echo "virtualenv on path: `which virtualenv`"
echo "virtualenv cmd: $VIRTUALENV_CMD"


python_version=`$PYTHON_CMD -c \
    'import sys; print("{}.{}.{}".format(*sys.version_info[:3]))'`
python_mm=${python_version:0:3}
python_m=${python_version:0:1}
case $INSTALL_TYPE in
macpython)
    if [ "$python_version" != "$VERSION" ]; then
        echo "Wrong macpython python version"
        RET=1
    fi
    ;;
system|macports)
    if [ "$python_mm" != "$VERSION" ]; then
        echo "Wrong macports python version"
        RET=1
    fi
    ;;
homebrew)
    if [ "$python_m" != "$VERSION" ]; then
        echo "Wrong homebrew python version"
        RET=1
    fi
    ;;
esac
if [ -n "$VENV" ]; then
    if [ "$PYTHON_CMD" != "$PWD/venv/bin/python" ]; then
        echo "Wrong virtualenv python"
        RET = 1
    fi
    if [ "$PIP_CMD" != "$PWD/venv/bin/pip" ]; then
        echo "Wrong virtualenv pip"
        RET=1
    fi
else # not virtualenv
    case $INSTALL_TYPE in
    system)
        if [ "$PYTHON_CMD" != "/usr/bin/python" ]; then
            echo "Wrong system python cmd"
            RET=1
        fi
        if [ "$PIP_CMD" != "sudo /usr/local/bin/pip" ]; then
            echo "Wrong system pip"
            RET=1
        fi
        ;;
    macpython)
        macpie_bin="$MACPYTHON_PREFIX/$python_mm/bin"
        if [ "$PYTHON_CMD" != "$macpie_bin/python$python_mm" ]; then
            echo "Wrong macpython python cmd"
            RET=1
        fi
        if [ "$PIP_CMD" != "sudo $macpie_bin/pip$python_mm" ]; then
            echo "Wrong macpython pip"
            RET=1
        fi
        ;;
    macports)
        if [ "$PYTHON_CMD" != "/opt/local/bin/python$python_mm" ]; then
            echo "Wrong macports python cmd"
            RET=1
        fi
        if [ "$PIP_CMD" != "sudo /opt/local/bin/pip-$python_mm" ]; then
            echo "Wrong macports pip"
            RET=1
        fi
        ;;
    homebrew)
        if [ "$PYTHON_CMD" != "/usr/local/bin/python$python_m" ]; then
            echo "Wrong homebrew python cmd"
            RET=1
        fi
        if [ "$PIP_CMD" != "/usr/local/bin/pip$python_m" ]; then
            echo "Wrong homebrew pip"
            RET=1
        fi
        ;;
    esac
fi
# Set the final return code
(exit $RET)
