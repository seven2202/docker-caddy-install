#!/bin/bash

# Ubuntu 一键安装 Docker + Caddy（带 HTTPS 自动配置）
# 使用方法：chmod +x install_docker_caddy.sh && sudo ./install_docker_caddy.sh

# 检查是否为 root 用户
if [ "$(id -u)" -ne 0 ]; then
  echo "请使用 root 用户或通过 sudo 运行此脚本"
  exit 1
fi

# 安装 Docker
echo "➤ 1. 安装 Docker..."
apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

# 启动 Docker 并设置开机自启
systemctl start docker
systemctl enable docker

# 安装 Docker Compose
echo "➤ 2. 安装 Docker Compose..."
curl -L "https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# 安装 Caddy
echo "➤ 3. 安装 Caddy..."
apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list
apt update
apt install -y caddy



# 启动 Caddy
systemctl enable caddy
systemctl restart caddy

# 验证安装
echo "➤ 5. 验证安装..."
docker --version
docker-compose --version
caddy version

echo "✅ 安装完成！"
echo "- Docker 和 Docker Compose 已安装"
echo "- Caddy 已安装并运行（配置见 /etc/caddy/Caddyfile）"
echo "- 请编辑 /etc/caddy/Caddyfile 配置你的域名和邮箱"
