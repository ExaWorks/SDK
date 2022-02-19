git clone -b master --single-branch https://github.com/radical-cybertools/radical.pilot.git

export RADICAL_PILOT_DBURL='mongodb://am:W6gvSzpGBqAeuR4Z@95.217.193.116:27017/am?tlsAllowInvalidCertificates=true'

cd radical.pilot
echo '--- smoke test'
./examples/00_getting_started.py
ret=$?
echo "--- smoke test $ret"

echo '--- unit test'
pytest -vvv tests/unit_tests
test "$ret" = 0 && ret=$?
echo "--- unit test $ret"

echo '--- component test'
pytest -vvv tests/component_tests
test "$ret" = 0 && ret=$?
echo "--- component test $ret"

echo "Success!"

exit $ret

