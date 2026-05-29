# Zsh 环境配置文档

> Ubuntu + Oh My Zsh + Powerlevel10k，快速复现个人环境用。

---

## 一、基础安装

```bash
# 1. 安装 zsh
sudo apt update && sudo apt install zsh -y

# 2. 安装 Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 3. 设置为默认 shell（若安装时未自动设置）
chsh -s $(which zsh)
# 重新登录后生效

# 4. 同步 chezmoi 配置
sudo snap install chezmoi --classic
chezmoi init https://github.com/EarthTan/dotfiles.git
echo "source ~/.config/zsh/init.zsh" >> ~/.zshrc


# 5. （optional） 获取解密密钥
sudo snap install bw
bw login
bw get notes age_key.txt
chezmoi apply
```

---

## 二、主题：Powerlevel10k

```bash
# 安装主题
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
```

重启终端后会自动进入交互式配置向导。若需重新配置：

```bash
p10k configure
```

### 终端字体（避免图标乱码）

```bash
# 下载 MesloLGS NF（p10k 官方推荐）
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
sudo mv *.ttf /usr/share/fonts/
fc-cache -fv
```

然后在终端模拟器设置中将字体改为 **MesloLGS NF**。

---

## 三、插件安装

需要手动 clone 的插件（oh-my-zsh 未内置）：

```bash
# zsh-autosuggestions（历史命令灰色提示）
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting（命令实时高亮）
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# zsh-completions（扩展 Tab 补全）
git clone https://github.com/zsh-users/zsh-completions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions

# zoxide
brew install zoxide
sudo apt install zoxide
```

其余插件（`extract`、`colored-man-pages`、`git`、`docker`、`node`）均为 oh-my-zsh 内置，无需额外安装。

---

## 五、PATH 问题修复, 引用配置文件

```bash
# 将路径加入 zshrc（以 ~/.local/bin 为例）
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.config/zsh/init.zsh
source ~/.zshrc
```

