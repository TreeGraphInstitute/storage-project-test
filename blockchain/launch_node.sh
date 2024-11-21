#!/bin/bash

# 检查是否提供了参数
if [ $# -eq 0 ]; then
    echo "错误: 请提供一个 0-3 之间的参数"
    exit 1
fi

# 获取参数
param=$1

# 检查参数是否在有效范围内
if ! [[ "$param" =~ ^[0-3]$ ]]; then
    echo "错误: 参数必须是 0、1、2 或 3"
    exit 1
fi

./make_sure_ready.sh

mkdir -p blockchain_data/net_config
echo "888800000000000000000000000000000000000000000000000000000000000${param}" > ./blockchain_data/net_config/key

cp ./pos_config/private_keys/${param} ./pos_config/pos_key
./conflux -c config.toml
