FROM rust:1.75-slim AS builder

WORKDIR /builder

RUN apt-get update && apt-get install -y clang libclang-dev libsqlite3-dev pkg-config libssl-dev cmake git

COPY ./stc-storage-kv .

RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/usr/local/cargo/git \
    cargo fetch

RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/usr/local/cargo/git \
    --mount=type=cache,target=/builder/target \
    cargo build --release -p zgs_kv

RUN --mount=type=cache,target=/builder/target cp /builder/target/release/zgs_kv ./zgs_kv


FROM ubuntu:latest

# 复制构建好的二进制文件到新的容器中
WORKDIR /app
RUN apt-get update && apt-get install -y vim curl jq dnsutils
COPY --from=builder /builder/zgs_kv .
COPY ./config.toml .
COPY ./log_config .
COPY ./launch_node.sh .
COPY ./check_ready.sh .
COPY ./make_sure_ready.sh .