FROM nginx:latest

RUN apt-get update && apt-get install -y vim curl jq dnsutils

WORKDIR /app
# 复制您的预处理脚本到镜像中
COPY launch_node.sh .
COPY check_ready.sh .
COPY make_sure_ready.sh .
COPY nginx.conf /etc/nginx/nginx.conf
# RUN nginx -t /etc/nginx/nginx.conf

CMD [ "./launch_node.sh" ]