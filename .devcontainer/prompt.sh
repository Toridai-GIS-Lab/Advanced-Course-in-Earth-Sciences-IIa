# 講義用の短いプロンプト
#   リポジトリ直下 → "course $"
#   data/raw にいる → "course/data/raw $"
__course_pwd() {
  local r="${CODESPACE_VSCODE_FOLDER:-/workspaces/Advanced-Course-in-Earth-Sciences-IIa}"
  case "$PWD" in
    "$r"|"$r"/*) printf '%s' "course${PWD#"$r"}" ;;
    *)           printf '%s' "${PWD/#$HOME/\~}" ;;
  esac
}
PS1='\[\e[1;36m\]$(__course_pwd)\[\e[0m\] \$ '
