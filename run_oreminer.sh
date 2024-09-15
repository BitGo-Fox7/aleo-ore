#!/bin/bash

# 设置钱包地址变量
WORKER_WALLET_ADDRESS="2N27ypJZwPdwbQHkmapCso3Nb9nUjRSdZytcDSCqHTCZ"

# 获取进程数量
PROCESSES=1

COMMAND_BASE="./ore-mine-pool-linux worker --route-server-url http://route.oreminepool.top:8080/ --server-url 'public&stake' --worker-wallet-address ${WORKER_WALLET_ADDRESS} >> worker.log 2>&1"

# 启动进程的函数
start_process() {
    local COMMAND="nohup $COMMAND_BASE > /dev/null 2>&1 &"
    eval "$COMMAND" > /dev/null 2>&1
}

# 启动进程
start_process > /dev/null 2>&1

# 后台运行，避免阻塞命令行
(
    trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

    # 循环检查进程是否运行
    while true; do
        num=$(ps aux | grep -w ore-mine-pool-linux | grep -v grep | wc -l)
        if [ "${num}" -lt "$PROCESSES" ]; then
            # 重定向所有输出到 /dev/null
            killall -9 ore-mine-pool-linux > /dev/null 2>&1
            start_process > /dev/null 2>&1
        fi
        sleep 10 > /dev/null 2>&1
    done
) &
