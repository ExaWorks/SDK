git clone -b master --single-branch https://github.com/radical-cybertools/radical.pilot.git

mkdir -p ~/.radical/pilot/configs/
cp resource_flux.json ~/.radical/pilot/configs/resource_flux.json

cd radical.pilot
echo '--- smoke test'
./examples/00_getting_started.py 'local.localhost_flux'
ret=$?
echo "--- smoke test $ret"

exit $ret
