#!/bin/bash


# 重置
reset='\033[0m'       # 文本重置

# 常规颜色
black='\033[0;30m'        # 黑色
red='\033[0;31m'          # 红色
green='\033[0;32m'        # 绿色
yellow='\033[0;33m'       # 黄色
blue='\033[0;34m'         # 蓝色
magenta='\033[0;35m'      # 洋红
cyan='\033[0;36m'         # 青色
white='\033[0;37m'        # 白色

# 粗体
bold_black='\033[1;30m'   # 粗体黑色
bold_red='\033[1;31m'     # 粗体红色
bold_green='\033[1;32m'   # 粗体绿色
bold_yellow='\033[1;33m'  # 粗体黄色
bold_blue='\033[1;34m'    # 粗体蓝色
bold_magenta='\033[1;35m' # 粗体洋红
bold_cyan='\033[1;36m'    # 粗体青色
bold_white='\033[1;37m'   # 粗体白色


function check_length() {
    local res=$(curl -s -X POST http://127.0.0.1:28545 -H "Content-Type: application/json" -d '{
        "jsonrpc":"2.0",
        "method":"eth_call",
        "params":[{
            "to": "0x33f2CFc729Bd870fA54b5032660e06B4CF2a7F94",
            "data": "0xfd54b228"
        }, "latest"],
        "id":1
        }' | jq -r ".result")
    local hex=${res:2:64}
    local dec=$(echo "ibase=16; ${hex^^}" | bc)
    echo -e "Current flow length: ${yellow}$dec${reset}"
    result=$(echo "scale=2; $dec * 256 / (2^40)" | bc)
    echo "Storage size: $result TB"
}

check_length
