# 循环引用所有配置文件
# ~/.config/zsh/init.zsh

eval "$(zoxide init zsh)"


_zsh_dir="${0:A:h}"

for f in "$_zsh_dir"/*.zsh; do
  [[ "$f" != "${0:A}" ]] && source "$f"
done



