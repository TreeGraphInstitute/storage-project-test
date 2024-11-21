# 使用 Node.js 的官方基础镜像
FROM node:18-alpine AS builder

# 设置工作目录
WORKDIR /builder

# 复制 package.json 和 yarn.lock 文件
COPY ./stc-storage-contracts/package.json ./stc-storage-contracts/yarn.lock ./

# 安装依赖，利用 Docker 层缓存
RUN --mount=type=cache,target=/builder/node_modules yarn install --frozen-lockfile

# 复制项目文件
COPY ./stc-storage-contracts .

# 构建应用
RUN --mount=type=cache,target=/builder/node_modules yarn build

RUN mkdir /out
RUN --mount=type=cache,target=/builder/node_modules cp -r /builder/node_modules /out/node_modules

# 使用另一个干净的阶段来准备最终镜像
FROM node:18-alpine

# 设置工作目录
WORKDIR /app

RUN apk add bash jq curl bind-tools

# 从构建器阶段复制构建的输出文件
COPY --from=builder /out/node_modules ./node_modules
COPY --from=builder /builder/build ./build
COPY --from=builder /builder/typechain-types ./typechain-types
COPY --from=builder /builder/contracts ./contracts
COPY --from=builder /builder/src ./src
COPY ./stc-storage-contracts/package.json ./
COPY ./transfer.ts ./src/dev
COPY ./hardhat.config.ts ./
COPY ./check_ready.sh ./
COPY ./make_sure_ready.sh ./
COPY ./deploy_contracts.sh ./