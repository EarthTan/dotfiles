# ── Oh My Zsh ────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# ── 插件 ─────────────────────────────────────────────────────────────────────
plugins=(
  # z
  zoxide
  git
  sudo
  extract
  colored-man-pages
  docker
  node
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
  universalarchive
)

source $ZSH/oh-my-zsh.sh

# ── PATH 补充（如有需要取消注释）─────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

# ── Powerlevel10k 配置文件 ────────────────────────────────────────────────────
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# zoxide 
eval "$(zoxide init zsh)"
