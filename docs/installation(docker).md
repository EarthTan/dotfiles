# docker 安装 （ubuntu，国内环境）

国内环境装 Docker 主要就是绕镜像源的问题。

```bash
# 1. 卸载旧版本（如有）
sudo apt remove docker docker-engine docker.io containerd runc 2>/dev/null

# 2. 安装依赖
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release

# 3. 添加 Docker GPG 密钥（用阿里云）
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg \
  | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# 4. 添加 apt 源（阿里云）
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://mirrors.aliyun.com/docker-ce/linux/ubuntu \
  $(lsb_release -cs) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 5. 安装 Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 6. 验证
sudo docker run hello-world
```

装完之后还要配**镜像拉取加速**，否则 `docker pull` 也会超时：

```bash
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<EOF
{
  "registry-mirrors": [
    "https://docker.m.daocloud.io",
    "https://dockerproxy.com",
    "https://mirror.baidubce.com"
  ]
}
EOF

sudo systemctl daemon-reload
sudo systemctl restart docker
```

**免 sudo 使用 Docker（可选）：**

```bash
sudo usermod -aG docker $USER
newgrp docker   # 或重新登录
```

几个备用镜像源，如果某个挂了可以换：

| 源                 | 地址                                   |
| ------------------ | -------------------------------------- |
| 阿里云（个人加速） | `https://<你的ID>.mirror.aliyuncs.com` |
| DaoCloud           | `https://docker.m.daocloud.io`         |
| 百度云             | `https://mirror.baidubce.com`          |
| 腾讯云             | `https://mirror.ccs.tencentyun.com`    |

阿里云个人加速器地址在 [cr.console.aliyun.com](https://cr.console.aliyun.com/) 登录后可以看到，每人一个专属地址，速度更稳定。
