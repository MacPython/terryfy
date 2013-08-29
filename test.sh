echo "python $PYTHON"
echo "nosetests $NOSETESTS"
echo "which"
which $PYTHON
which $NOSETESTS

$PYTHON -c "import matplotlib"
$NOSETESTS .
