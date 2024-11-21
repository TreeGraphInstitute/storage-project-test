#!/bin/bash

max_retries=60
attempt=1
args=$@

# 常用颜色
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
purple='\033[0;35m'
cyan='\033[0;36m'
white='\033[0;37m'
gray='\033[0;90m'

# 重置颜色
reset='\033[0m'

# 函数：执行脚本并检查结果
run_script() {
    echo -ne "${gray}"
    ./check_ready.sh $args
    local exit_code=$?
    echo -ne "${reset}"
    return $exit_code
}

# 循环，直到脚本成功执行或达到最大重试次数
while true; do
  echo "Attempt $attempt of $max_retries"
  # 调用函数
  if run_script; then
    echo -e "${green}Ready check: passed. ${reset}"
    echo ""
    break
  else
    echo -e "${yellow}Ready check: pending. ${reset}"
    attempt=$((attempt + 1))
    if [ "$attempt" -gt "$max_retries" ]; then
      echo -e "${red}Ready check: failed.${reset}"
      exit 1
    fi
    sleep 10
  fi
done
