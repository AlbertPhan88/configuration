# Tmux Cheatsheet

Prefix key: **Ctrl+a**

## Sessions

| Action | Command |
|--------|---------|
| New session | `tmux new -s name` |
| List sessions | `tmux ls` |
| Attach to session | `tmux attach -t name` |
| Detach | `prefix` + `d` |
| Kill session | `tmux kill-session -t name` |
| Rename session | `prefix` + `$` |
| Switch session | `prefix` + `s` |

## Windows

| Action | Keys |
|--------|------|
| New window | `prefix` + `c` |
| Next window | `Shift+Right` |
| Previous window | `Shift+Left` |
| Select by number | `prefix` + `0-9` |
| Rename window | `prefix` + `,` |
| Close window | `prefix` + `&` |
| Move window left | `prefix` + `<` |
| Move window right | `prefix` + `>` |
| List windows | `prefix` + `w` |

## Panes

| Action | Keys |
|--------|------|
| Split horizontal | `prefix` + `\|` |
| Split vertical | `prefix` + `-` |
| Navigate (arrows) | `Alt+Arrow` |
| Navigate (vim) | `prefix` + `h/j/k/l` |
| Resize | `prefix` + `H/J/K/L` |
| Close pane | `prefix` + `x` |
| Toggle zoom | `prefix` + `z` |
| Show pane numbers | `prefix` + `q` |
| Convert pane to window | `prefix` + `!` |

## Copy Mode (vi)

| Action | Keys |
|--------|------|
| Enter copy mode | `prefix` + `[` |
| Start selection | `v` |
| Copy selection | `y` |
| Paste | `prefix` + `]` |
| Search forward | `/` |
| Search backward | `?` |
| Next match | `n` |
| Previous match | `N` |
| Scroll up/down | `Ctrl+u` / `Ctrl+d` |
| Mouse select | Drag to select, auto-copies |

## Other

| Action | Keys / Command |
|--------|----------------|
| Reload config | `prefix` + `r` |
| Command prompt | `prefix` + `:` |
| Show clock | `prefix` + `t` |
| Show key bindings | `prefix` + `?` |
