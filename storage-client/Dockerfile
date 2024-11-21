FROM golang:1.21-alpine AS builder

# Set up dependencies
# bash, jq, curl for debugging
# git, make for installation
# libc-dev, gcc, linux-headers, eudev-dev are used for cgo and ledger installation
RUN apk add bash git make libc-dev gcc linux-headers eudev-dev jq curl

WORKDIR /builder

COPY ./stc-storage-client/go.mod ./
COPY ./stc-storage-client/go.sum ./

# Download dependencies
RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg/mod \
    go version && go mod download

COPY ./stc-storage-client .

RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg/mod \
    go build

FROM alpine:3.15

RUN apk add bash jq curl bind-tools

WORKDIR /app
COPY --from=builder /builder/0g-storage-client .
COPY ./fill_data.sh .
COPY ./check_ready.sh .
COPY ./start_upload.sh .
COPY ./make_sure_ready.sh .