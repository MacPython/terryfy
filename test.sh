if [ "$TEST" == "brew_system" ]
then
    $NOSETESTS .
elif [ "$TEST" == "brew_py" ]
then
    $NOSETESTS .
elif [ "$TEST" == "brew_py3" ]
then
    $NOSETESTS .
elif [ "$TEST" == "macports_py26" ]
then
    $NOSETESTS .
elif [ "$TEST" == "macports_py27" ]
then
    $NOSETESTS .
elif [ "$TEST" == "macports_py32" ]
then
    $NOSETESTS .
elif [ "$TEST" == "macports_py33" ]
then
    $NOSETESTS .
elif [ "$TEST" == "macpython27_10.8" ]
then
    $NOSETESTS .
elif [ "$TEST" == "macpython27_10.8_numpy" ]
then
    $NOSETESTS .
elif [ "$TEST" == "macpython33_10.8" ]
then
    $NOSETESTS .
elif [ "$TEST" == "brew_system_venv" ]
then
    $NOSETESTS .
elif [ "$TEST" == "brew_py_venv" ]
then
    $NOSETESTS .
elif [ "$TEST" == "brew_py3_venv" ]
then
    $NOSETESTS .
elif [ "$TEST" == "macports_py26_venv" ]
then
    $NOSETESTS .
elif [ "$TEST" == "macports_py27_venv" ]
then
    $NOSETESTS .
elif [ "$TEST" == "macports_py32_venv" ]
then
    $NOSETESTS .
elif [ "$TEST" == "macports_py33_venv" ]
then
    $NOSETESTS .
else
    echo "Unknown test setting ($TEST)"
fi
