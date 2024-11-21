
#!/bin/bash

idx=$1

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

# 生成一个随机文件名
random_name=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13 ; echo '')
name="bulk_${random_name}"
echo -e "${bold_white}Make random file${reset}"
# 创建随机命名的 bulk 文件
dd if=/dev/urandom of="${name}" bs=1024k count=8192

# 设置重试次数
max_retries=10
attempt=1

while [ $attempt -le $max_retries ]; do
    echo -e "${bold_white}Attempt $attempt of $max_retries...${reset}"
    nice -n 10 ./0g-storage-client upload \
        --log-level debug \
        --node http://storage0:5678,http://storage1:5678,http://storage2:5678,http://storage3:5678 \
        --url http://chain$idx:8545/ \
        --key fafafafafafafafafafafafafafafafafafafafafafafafafafafafafafafa0$idx \
        --file $name
    
    # 检查上一个命令的退出状态
    if [ $? -eq 0 ]; then
        echo -e "${green}Upload successful!${reset}"
        break
    else
        echo -e "${yellow}Upload failed, retrying...${reset}"
        attempt=$((attempt + 1))
        sleep 10
    fi
done

rm ${name}

if [ $attempt -gt $max_retries ]; then
    echo -e "${red}Upload failed after $max_retries attempts.${reset}"
    exit 1
fi