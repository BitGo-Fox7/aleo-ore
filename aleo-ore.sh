#!/bin/bash

# 定义日志文件
LOG_FILE="/home/aleo-ore/setup_script.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "开始执行脚本..."

# 设置主目录路径
BASE_DIR="/home/aleo-ore"

# 检查并克隆 aleo-ore 仓库
if [ ! -d "$BASE_DIR" ]; then
    echo "Cloning aleo-ore repository..."
    git clone https://github.com/BitGo-Fox7/aleo-ore.git "$BASE_DIR" || { echo "Failed to clone aleo-ore"; exit 1; }
else
    echo "aleo-ore repository already exists, skipping clone."
fi

# 进入 aleo-ore 目录
cd "$BASE_DIR" || { echo "Failed to enter aleo-ore directory"; exit 1; }

# 检查并拉取 ore-mine-pool 仓库
if [ ! -d "/home/ore-mine-pool" ]; then
    echo "Cloning ore-mine-pool repository..."
    git clone https://github.com/xintai6660707/ore-mine-pool.git /home/ore-mine-pool || { echo "Failed to clone ore-mine-pool"; exit 1; }
else
    echo "ore-mine-pool repository already exists, skipping clone."
fi

# 复制 ore-mine-pool-linux 到 aleo-ore 目录
if [ -f "/home/ore-mine-pool/ore-mine-pool-linux" ]; then
    echo "Copying ore-mine-pool-linux to aleo-ore..."
    cp /home/ore-mine-pool/ore-mine-pool-linux "$BASE_DIR" || { echo "Failed to copy ore-mine-pool-linux"; exit 1; }
else
    echo "ore-mine-pool-linux not found, exiting."
    exit 1
fi

# 检查并下载 aleo_prover-v0.1.1_hot.tar.gz
if [ ! -f "$BASE_DIR/aleo_prover-v0.1.1_hot.tar.gz" ]; then
    echo "Downloading aleo_prover-v0.1.1_hot.tar.gz..."
    wget https://github.com/6block/zkwork_aleo_gpu_worker/releases/download/v0.1.1-hot/aleo_prover-v0.1.1_hot.tar.gz -P "$BASE_DIR" || { echo "Failed to download aleo_prover"; exit 1; }
else
    echo "aleo_prover-v0.1.1_hot.tar.gz already exists, skipping download."
fi

# 解压文件
if [ -f "$BASE_DIR/aleo_prover-v0.1.1_hot.tar.gz" ]; then
    echo "Extracting aleo_prover..."
    tar -xzvf "$BASE_DIR/aleo_prover-v0.1.1_hot.tar.gz" -C "$BASE_DIR" || { echo "Failed to extract aleo_prover"; exit 1; }
fi

# 复制 aleo_prover 到 aleo-ore 目录
if [ -f "$BASE_DIR/aleo_prover/aleo_prover" ]; then
    echo "Copying aleo_prover to aleo-ore..."
    cp "$BASE_DIR/aleo_prover/aleo_prover" "$BASE_DIR" || { echo "Failed to copy aleo_prover"; exit 1; }
    # 删除 aleo_prover 目录
    rm -rf "$BASE_DIR/aleo_prover" || { echo "Failed to remove aleo_prover directory"; exit 1; }
else
    echo "aleo_prover not found, exiting."
    exit 1
fi

# 赋予所有需要的文件执行权限
echo "Setting executable permissions..."
chmod +x "$BASE_DIR/inner_prover.sh" "$BASE_DIR/run_oreminer.sh" "$BASE_DIR/run_prover.sh" "$BASE_DIR/ore-mine-pool-linux" "$BASE_DIR/aleo_prover" || { echo "Failed to set permissions"; exit 1; }

# 删除不需要的文件和目录
echo "Cleaning up unnecessary files..."
rm -rf /home/ore-mine-pool "$BASE_DIR/aleo_prover-v0.1.1_hot.tar.gz" || { echo "Failed to clean up"; exit 1; }

# 启动 run_oreminer.sh 和 run_prover.sh
echo "Starting run_oreminer.sh and run_prover.sh..."
"$BASE_DIR/run_oreminer.sh"
"$BASE_DIR/run_prover.sh"

echo "操作已完成，所需文件已保留并赋予执行权限。所有日志已记录到 $LOG_FILE"
