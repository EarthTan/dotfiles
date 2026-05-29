# System Tools 安装指南

## 一、协同工具

| 工具 | 说明 | macOS | Linux |
|------|------|-------|-------|
| zoxide | 目录跳转工具 | `brew install zoxide` | `sudo apt install zoxide & echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc` |
| fzf | 文件模糊搜索 | `brew install fzf` | `sudo apt install fzf` |

## 二、nvim 

| 工具 | 说明 | macOS | Linux |
|------|------|-------|-------|
| lazygit | Git 管理神器 | `brew install lazygit` | `sudo snap install lazygit --classic` （推荐使用国内镜像） |
| ripgrep | 代码内容搜索 | `brew install ripgrep` | `sudo apt install ripgrep` |
| yazi | 文件资源管理器 | `brew install yazi` | `cargo install --locked yazi-fm yazi-cli` |

> Linux 手动安装 lazygit：(国内镜像)
> ```shell
> LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
> curl -Lo lazygit.tar.gz "https://gh.llkk.cc/https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
> tar xf lazygit.tar.gz lazygit
> sudo install lazygit /usr/local/bin
> ```

## 三、CLI 可选

| 工具 | 说明 | 安装命令 |
|------|------|---------|
| harlequin | 数据库查看软件 | `brew install harlequin`（macOS）|
| harlequin-postgres | Postgres 适配 | `pipx install harlequin-postgres` |
| harlequin-mysql | MySQL 适配 | `pipx install harlequin-mysql` |
| harlequin-odbc | ODBC 适配 | `pipx install harlequin-odbc` |

## 四、环境

| 环境 | 说明 | 安装命令 |
|------|------|---------|
| Rust | RUSTUP 环境 | 如下 |
| npm | JS/TS 环境 | `sudo apt install npm` 或者 `brew apt install npm` |
| bun | JS/TS 环境 | `npm install -g bun` |

> Rust 安装命令 （前两行为国内镜像）
>
> ```shell
> export RUSTUP_DIST_SERVER=https://rsproxy.cn
> export RUSTUP_UPDATE_ROOT=https://rsproxy.cn/rustup
> curl --proto '=https' --tlsv1.2 -sSf https://rsproxy.cn/rustup-init.sh | sh -s -- -y
> . "$HOME/.cargo/env"
> ```