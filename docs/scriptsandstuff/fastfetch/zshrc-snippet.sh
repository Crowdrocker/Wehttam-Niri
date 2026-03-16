## ╔══════════════════════════════════════════════════════════════════╗
## ║  Fastfetch integration — add to ~/.zshrc                        ║
## ║  Shows branded system info on every new terminal                ║
## ╚══════════════════════════════════════════════════════════════════╝

# Run fastfetch on terminal open (only in interactive shells, not scripts)
# Comment out if you find it too slow — use the 'ff' alias manually instead
if [[ $- == *i* ]] && command -v fastfetch &>/dev/null; then
    fastfetch
fi

# Quick re-run alias
alias ff='fastfetch'

# Minimal mode (no logo, just stats) — useful inside tmux splits
alias ffs='fastfetch --logo none'

# Gaming stats mode (CPU/GPU/RAM only — fast)
alias ffg='fastfetch --structure Title:Separator:CPU:CPUUsage:GPU:Memory:Swap:Break:Colors'
