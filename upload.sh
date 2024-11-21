
#!/bin/bash

# 生成一个随机文件名
random_name=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13 ; echo '')
name="bulk_${random_name}"
echo "make random file"
# 创建随机命名的 bulk 文件
dd if=/dev/urandom of="${name}" bs=1024k count=10240

# 设置重试次数
max_retries=3
attempt=1

# 上传文件，最多重试三次
while [ $attempt -le $max_retries ]; do
    echo "Attempt $attempt of $max_retries..."
    ./storage-client/stc-storage-client/0g-storage-client upload \
        --node http://127.0.0.1:15000,http://127.0.0.1:15001,http://127.0.0.1:15002,http://127.0.0.1:15003 \
        --url http://127.0.0.1:14000/ \
        --key 9a6d3ba2b0c7514b16a006ee605055d71b9edfad183aeb2d9790e9d4ccced471 \
        --file $name
    
    # 检查上一个命令的退出状态
    if [ $? -eq 0 ]; then
        echo "Upload successful!"
        break
    else
        echo "Upload failed, retrying..."
        attempt=$((attempt + 1))
    fi
done

# 如果重试三次后仍然失败，输出错误信息
if [ $attempt -gt $max_retries ]; then
    echo "Upload failed after $max_retries attempts."
    exit 1
fi