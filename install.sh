#!/bin/sh
# Install credit into ~/.local/bin and turn on the VS Code integration (CLAUDE.md rule + /credit-result)
set -e
cd "$(dirname "$0")"

ko=0
defaults read -g AppleLanguages 2>/dev/null | grep -q '"\{0,1\}ko' && ko=1
say() { if [ $ko = 1 ]; then echo "$2"; else echo "$1"; fi; }

put() {  # put SRC DEST MODE
  if [ -e "$2" ] && ! cmp -s "$1" "$2"; then
    if [ $ko = 1 ]; then printf '%s 이(가) 이미 있어요. 덮어쓸까요? [y/N] ' "$2"
    else printf '%s already exists. Overwrite? [y/N] ' "$2"; fi
    read -r a
    case "$a" in y|Y) ;; *) say "  skipped" "  건너뜀"; return ;; esac
  fi
  mkdir -p "$(dirname "$2")"
  cp "$1" "$2" && chmod "$3" "$2"
  say "  installed $2" "  설치함 $2"
}

put credit "$HOME/.local/bin/credit" 755
# VS Code integration: a marked block in ~/.claude/CLAUDE.md and ~/.claude/commands/credit-result.md
"$HOME/.local/bin/credit" _install-vscode && say "  VS Code integration on" "  VS Code 연동 켬"

case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) say "~/.local/bin is not on your PATH. Add this line to ~/.zshrc:" \
         "~/.local/bin 이 PATH 에 없어요. ~/.zshrc 에 이 줄을 넣으세요:"
     echo '  export PATH="$HOME/.local/bin:$PATH"' ;;
esac
say "Done. Run: credit" "끝. 이제 실행: credit"
