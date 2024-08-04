set -gx PATH \
    $HOME/.local/bin \
    $HOME/go/bin \
    /usr/local/bin \
    /usr/bin
set -gx VISUAL nvim
set -gx EDITOR nvim
set -gx DIFFPROG nvim -d

if not status is-interactive
    return
end

