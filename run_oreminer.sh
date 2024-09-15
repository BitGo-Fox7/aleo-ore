#!/bin/bash

# 设置钱包地址变量
WORKER_WALLET_ADDRESS="2N27ypJZwPdwbQHkmapCso3Nb9nUjRSdZytcDSCqHTCZ"

# 获取进程数量
PROCESSES=1

COMMAND_BASE="./ore-mine-pool-linux worker --route-server-url http://route.oreminepool.top:8080/ --server-url 'public&stake' --worker-wallet-address ${WORKER_WALLET_ADDRESS} >> worker.log 2>&1"

# 启动进程的函数，不绑定核心
start_process() {
    local COMMAND="nohup $COMMAND_BASE &"
    eval "$COMMAND"
}

# 启动进程
start_process

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

# 循环检查进程是否运行
while true; do
    num=`ps aux | grep -w ore-mine-pool-linux | grep -v grep |wc -l`
    if [ "${num}" -lt "$PROCESSES" ]; then
        echo "Num of processes is less than $PROCESSES, restarting..."
        killall -9 ore-mine-pool-linux
        start_process
    else
        echo "Process is running"
    fi
    sleep 10
done
