#!/bin/bash

param=$1

if ! nslookup "chain${param}" > /dev/null 2>&1; then
    echo "chain is not launched"
    exit 1
fi

eth_node_url="http://chain${param}:8545"

function check_contract() {
    local contract_address=$1
    contract_code=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_getCode","params":["'$contract_address'", "latest"],"id":1}' -H "Content-Type: application/json" $eth_node_url | jq -r ".result")
    echo "get contract code $contract_code"

    if [[ ${#contract_code} -lt 10 ]]; then
        echo "No code at $contract_address."
        exit 1
    else
        echo "Code found at $contract_address."
    fi
}

check_contract 0x615d7c6A00335688F35D40Bb27735B7B2DBfDa97
check_contract 0x33f2CFc729Bd870fA54b5032660e06B4CF2a7F94