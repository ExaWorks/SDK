git clone -b feature/parsl_raptor_executor --single-branch https://github.com/radical-cybertools/radical.pilot.git

mkdir -p ~/.radical/pilot/runs/
cp radical.pilot/examples/parsl/*  ~/.radical/pilot/runs/
cp radical.pilot/examples/parsl/map_reduce.py ~/.radical/pilot/runs/

cd ~/.radical/pilot/runs/

[ -z ${RADICAL_PILOT_DBURL} ] && echo "\${RADICAL_PILOT_DBURL} not defined"

echo '--- smoke test'
chmod +x map_reduce.py
python map_reduce.py
ret=$?
echo "--- smoke test $ret"

echo "Success!"
