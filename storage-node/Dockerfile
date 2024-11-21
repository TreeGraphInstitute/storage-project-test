FROM rust:1.75-slim AS builder

WORKDIR /builder

RUN apt-get update && apt-get install -y clang libclang-dev libsqlite3-dev pkg-config libssl-dev cmake git

COPY ./stc-storage-node .

RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/usr/local/cargo/git \
    cargo fetch

RUN sed -i \
    -e 's/\(\.with_writer(non_blocking)\)/\/\/ \1/' \
    -e 's/\(\.with_ansi(false)\)/\/\/ \1/' \
    ./node/src/log.rs

RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/usr/local/cargo/git \
    --mount=type=cache,target=/builder/target \
    cargo build --release


RUN --mount=type=cache,target=/builder/target cp /builder/target/release/zgs_node ./zgs_node


FROM ubuntu:latest

# 复制构建好的二进制文件到新的容器中
WORKDIR /app
RUN apt-get update && apt-get install -y vim curl jq dnsutils
COPY --from=builder /builder/zgs_node .
COPY ./config.toml .
COPY ./log_config .
COPY ./launch_node.sh .
COPY ./check_healthy.sh .
COPY ./check_ready.sh .
COPY ./make_sure_ready.sh .