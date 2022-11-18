if which radical-pilot-version >/dev/null; then
    rp_version="$(radical-pilot-version)"
    if [[ -z $rp_version ]]; then
        echo "RADICAL-Pilot version unknown"
        exit 1
    fi
else
    echo "RADICAL-Pilot not installed"
    exit 1
fi

git clone -b v$rp_version --single-branch https://github.com/radical-cybertools/radical.pilot.git
cd radical.pilot

echo '--- smoke test'
./examples/00_getting_started.py local.localhost_test
ret=$?
echo "--- smoke test $ret"

SID=$(ls -rt | grep rp.session)
test -z "$SID" || rm -rf "$HOME/radical.pilot.sandbox/$SID"

echo '--- unit test'
pytest -vvv tests/unit_tests
test "$ret" = 0 && ret=$?
echo "--- unit test $ret"

echo '--- component test'
pytest -vvv tests/component_tests
test "$ret" = 0 && ret=$?
echo "--- component test $ret"

test "$ret" = 0 && echo "Success!"
exit $ret

