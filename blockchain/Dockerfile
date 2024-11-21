FROM rust:1.77.2-slim AS builder

WORKDIR /builder

RUN apt-get update && apt-get install -y clang libclang-dev libsqlite3-dev pkg-config libssl-dev cmake git

COPY ./stc-conflux-rust .

RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/usr/local/cargo/git \
    cargo fetch

RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/usr/local/cargo/git \
    --mount=type=cache,target=/builder/target \
    cargo build --release

RUN --mount=type=cache,target=/builder/target cp /builder/target/release/conflux ./conflux


FROM ubuntu:latest

# 复制构建好的二进制文件到新的容器中
WORKDIR /app
RUN apt-get update && apt-get install -y vim curl jq dnsutils
COPY --from=builder /builder/conflux .
COPY ./config.toml .
COPY ./stc-conflux-rust/run/log.yaml .
COPY ./stc-conflux-rust/run/throttling.toml .
COPY ./pos_config ./pos_config
COPY ./launch_node.sh .
COPY ./check_healthy.sh .
COPY ./check_ready.sh .
COPY ./make_sure_ready.sh .

# COPY --from=builder /app/run/config.toml ./config.toml