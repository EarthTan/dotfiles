sv() {
  local target="${1:-.}"  # 默认当前目录
  if [ -f "${target}/.venv/bin/activate" ]; then
    source "${target}/.venv/bin/activate"
  else
    echo "No .venv found in ${target}"
  fi
}
