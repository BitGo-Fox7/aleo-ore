# server list
pool=aleo.hk.zk.work:10003

# use your own aleo reward_address
reward_address=aleo1pkp2kghfnnsy45nzupf7hzx5tkmwc7jlgq6j7mp95ukp94rh9c8qpuencd

# set your own custom name
custom_name="8888"

pids=$(ps -ef | grep aleo_prover | grep -v grep | awk '{print $2}')
if [ -n "$pids" ]; then
    echo "$pids" | xargs kill
    sleep 5
fi

while true; do
    target=`ps aux | grep aleo_prover | grep -v grep`
    if [ -z "$target" ]; then
        ./aleo_prover --address $reward_address --pool $pool --custom_name $custom_name
        sleep 5
    fi
    sleep 60
done

