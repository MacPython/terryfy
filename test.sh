echo "python $PYTHON"
which $PYTHON

echo "pip $PIP"
which $PIP

echo "sanity checks"
$PYTHON -c "import dateutil; print(dateutil.__version__)"
$PYTHON -c "import sys; print('\n'.join(sys.path))"
$PYTHON -c "import matplotlib; print(matplotlib.__file__)"
$PYTHON -c "from matplotlib import font_manager"

echo "testing matplotlib using 8 processess"
$PYTHON ../matplotlib/tests.py -sv --processes=8 --process-timeout=300
