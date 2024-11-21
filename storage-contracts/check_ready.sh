#!/bin/bash

if ! nslookup "chain0" > /dev/null 2>&1; then
    echo "chain0 is not launched"
    exit 1
fi

# 运行命令并捕获输出
hex_epoch_number=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"cfx_getBlockByEpochNumber","params":["latest_state", false],"id":1}' -H "Content-Type: application/json" chain0:12537 | jq -r ".result.epochNumber")

# 检查 jq 是否成功提取了 epochNumber
if [ $? -ne 0 ] || [ -z "$hex_epoch_number" ] || [ "$hex_epoch_number" == "null" ]; then
    echo "Failed to extract epochNumber from the command output."
    exit 1
fi

echo "Extracted hex epochNumber: $hex_epoch_number"

dec_epoch_number=$((16#${hex_epoch_number#0x}))

echo "Decimal epochNumber: $dec_epoch_number"

# 检查 epochNumber 是否小于 5
if [ "$dec_epoch_number" -lt 5 ]; then
    echo "epochNumber is less than 5. Exiting with status 1."
    exit 1
else
    echo "epochNumber is 5 or greater."
fi

echo "Script completed successfully."