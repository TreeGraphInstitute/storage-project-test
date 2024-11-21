#!/bin/bash

# export BUILD_PROXY=http://192.168.1.169:1082
# export DOCKER_DEBUG=1

set -e

# 检查环境变量yyy是否设置
if [[ -n $BUILD_PROXY ]]; then
    ARGS=(--build-arg HTTP_PROXY="$BUILD_PROXY" --build-arg HTTPS_PROXY="$BUILD_PROXY")
else
    ARGS=()
fi

if [[ $DOCKER_DEBUG -eq 1 ]]; then
    ARGS+=(--progress=plain)
fi

cd blockchain
cp ../make_sure_ready.sh .
docker build -t stc-chain ${ARGS[@]} .
rm make_sure_ready.sh
cd ..

cd storage-contracts
cp ../make_sure_ready.sh .
docker build -t stc-storage-contracts ${ARGS[@]} .
rm make_sure_ready.sh
cd ..

cd storage-node
cp ../make_sure_ready.sh .
docker build -t stc-storage-node ${ARGS[@]} .
rm make_sure_ready.sh
cd ..

cd storage-client
cp ../make_sure_ready.sh .
docker build -t stc-storage-client ${ARGS[@]} .
rm make_sure_ready.sh
cd ..

cd storage-kv
cp ../make_sure_ready.sh .
docker build -t stc-storage-kv ${ARGS[@]} .
rm make_sure_ready.sh
cd ..

cd reverse-proxy
cp ../make_sure_ready.sh .
docker build -t stc-reverse-proxy ${ARGS[@]} .
rm make_sure_ready.sh
cd ..