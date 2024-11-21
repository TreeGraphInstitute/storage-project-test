#!/bin/bash

# 运行命令并捕获输出
hex_epoch_number=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"cfx_getBlockByEpochNumber","params":["latest_state", false],"id":1}' -H "Content-Type: application/json" http://chain0:12537 | jq -r ".result.epochNumber")

# 检查 jq 是否成功提取了 epochNumber
if [ $? -ne 0 ] || [ -z "$hex_epoch_number" ] || [ "$hex_epoch_number" == "null" ]; then
    echo "Failed to extract epochNumber from the command output."
    exit 1
fi

echo "Extracted hex epochNumber: $hex_epoch_number"

dec_epoch_number=$((16#${hex_epoch_number#0x}))

echo "Epoch Number: $dec_epoch_number"

log_sync_number=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"zgs_getStatus", "params": [], "id": 1}' -H "Content-Type: application/json" http://localhost:5678 | jq -r ".result.logSyncHeight")
echo "Log Sync Number: $log_sync_number"

diff=$((dec_epoch_number > log_sync_number ? dec_epoch_number - log_sync_number : log_sync_number - dec_epoch_number))

if [[ "$log_sync_number" -lt 100 ]]; then
    echo "log sync less than 100"
    exit 1
fi

if [[ "$diff" -gt 300 ]]; then
    echo "too large diff"
    exit 1
fi

echo "Check Pass"