echo "which nose"
which nosetests

echo "what is in /usr/local/bin"
ls /usr/local/bin/*

echo "what is in /opt/local/bin"
ls /opt/local/bin/*

echo $PATH

if [ "$TEST" == "brew_system" ]
then
    nosetests .
elif [ "$TEST" == "brew_py" ]
then
    nosetest .
elif [ "$TEST" == "brew_py3" ]
then
    nosetests .
elif [ "$TEST" == "macports_py26" ]
then
    /opt/local/bin/nosetests-2.6 .
elif [ "$TEST" == "macports_py27" ]
then
    /opt/local/bin/nosetests-2.7 .
elif [ "$TEST" == "macports_py32" ]
then
    /opt/local/bin/nosetests-3.2 .
elif [ "$TEST" == "macports_py33" ]
then
    /opt/local/bin/nosetests-3.3 .
else
    echo "Unknown test setting ($TEST)"
fi
