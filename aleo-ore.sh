#!/bin/bash

# 定义日志文件
LOG_FILE="/home/aleo-ore/setup_script.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "开始执行脚本..."

# 设置路径
BASE_DIR="/home/aleo-ore"

# 克隆 aleo-ore 仓库到 aleo-ore 目录
echo "Cloning aleo-ore repository..."
git clone https://github.com/BitGo-Fox7/aleo-ore.git "$BASE_DIR"

# 克隆 ore-mine-pool 仓库到 /home 目录
echo "Cloning ore-mine-pool repository..."
git clone https://github.com/xintai6660707/ore-mine-pool.git /home/ore-mine-pool

# 下载 aleo_prover-v0.1.1_hot.tar.gz 到 /home 目录
echo "Downloading aleo_prover-v0.1.1_hot.tar.gz to /home..."
wget https://github.com/6block/zkwork_aleo_gpu_worker/releases/download/v0.1.1-hot/aleo_prover-v0.1.1_hot.tar.gz -P /home

# 解压 aleo_prover-v0.1.1_hot.tar.gz 到 /home
echo "Extracting aleo_prover..."
tar -xzvf /home/aleo_prover-v0.1.1_hot.tar.gz -C /home

# 复制 ore-mine-pool-linux 和 aleo_prover 到 aleo-ore 目录
echo "Copying ore-mine-pool-linux and aleo_prover to aleo-ore..."
cp /home/ore-mine-pool/ore-mine-pool-linux "$BASE_DIR"
cp /home/aleo_prover/aleo_prover "$BASE_DIR"

# 删除 /home 目录下的 ore-mine-pool 文件夹和 aleo_prover-v0.1.1_hot.tar.gz 压缩包
echo "Removing unnecessary files and directories in /home..."
rm -rf /home/ore-mine-pool /home/aleo_prover /home/aleo_prover-v0.1.1_hot.tar.gz

# 赋予 aleo-ore 文件夹中所有文件执行权限
echo "Setting executable permissions for all files in aleo-ore..."
chmod +x "$BASE_DIR"/*

# 进入 aleo-ore 目录并启动 run_oreminer.sh 和 run_prover.sh
echo "Starting run_oreminer.sh and run_prover.sh..."
cd "$BASE_DIR"
./run_oreminer.sh
./run_prover.sh

echo "操作已完成，所需文件已保留并赋予执行权限。所有日志已记录到 $LOG_FILE"
