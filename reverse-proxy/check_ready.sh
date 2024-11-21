#!/bin/bash
domains=("chain0" "chain1" "chain2" "chain3")

for domain in "${domains[@]}"; do
    if ! nslookup "$domain" > /dev/null 2>&1; then
        echo "cannot find $domain"
        exit 1
    fi
done