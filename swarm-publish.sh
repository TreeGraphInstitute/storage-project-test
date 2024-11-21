#!/bin/bash

function publish() {
    docker tag $1 localhost:5000/$1:latest
    docker push localhost:5000/$1:latest
}

publish stc-chain
publish stc-storage-contracts
publish stc-storage-node
publish stc-storage-client
publish stc-storage-kv
publish stc-reverse-proxy