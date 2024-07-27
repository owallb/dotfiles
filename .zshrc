
_here="$(dirname -- "$(readlink -f -- "${HOME}/.zshrc")")"

###########
# Options #
###########
# Ref: https://zsh.sourceforge.io/Doc/Release/Options.html

setopt CORRECT
setopt INTERACTIVE_COMMENTS
unsetopt NOMATCH

# History
setopt BANG_HIST
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY_TIME

###################
# Shell Variables #
###################
# Ref: https://zsh.sourceforge.io/Doc/Release/Parameters.html

path=("${HOME}/.local/bin" "${path[@]}")
fpath=("${_here}/.zsh_functions" "${fpath[@]}")
export PATH
export MAIL="/var/spool/mail/$USER"
export MAILCHECK=60
export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=100100
export SAVEHIST=100000

###################
# Other Variables #
###################

export VISUAL="nvim"
export EDITOR="nvim"
export DIFFPROG="nvim -d"
export NNN_TRASH=2
export NNN_PLUG=''

###########
# Plugins #
###########

if [[ ! -d "${_here}/.cache" ]]; then
    mkdir "${_here}/.cache"
fi

_antidote="${_here}/.cache/.antidote"
_plugins="${_here}/.zsh_plugins.txt"
_plugins_cache="${_here}/.cache/.zsh_plugins.zsh"

if [[ ! -d "$_antidote" ]]; then
    git clone --depth=1 https://github.com/mattmc3/antidote.git "$_antidote"
fi

if [[ ! -f "${_plugins}" ]]; then
    touch "${_plugins}"
fi

fpath=("${_antidote}/functions" "${fpath[@]}")
autoload -Uz antidote

if [[ ! "${_plugins_cache}" -nt "${_plugins}" ]]; then
    antidote bundle <"${_plugins}" >"${_plugins_cache}"
fi

# shellcheck source=.cache/.zsh_plugins.zsh
source "${_plugins_cache}"

unset _antidote _plugins _plugins_cache

#############
# Functions #
#############
# Ref: https://zsh.sourceforge.io/Doc/Release/Functions.html#Functions

function set_terminal_title() {
    local title
    if [ -z "$1" ]; then
        title=$(basename "$(print -P "%~")")
    else
        title="$1"
    fi
    echo -ne "\033]2;$title\033\\"
}

function precmd() {
    set_terminal_title
}

function ssh_with_title() {
    local host=""
    local skip_next="false"

    for arg in "$@"; do
        case "$arg" in
        -[bcDeFIiLlmOopRSWw]?*)
            # Option with argument immediately after, like -p22
            skip_next="false"
            ;;
        -[bcDeFIiLlmOopRSWw])
            # Option with argument on next iteration
            skip_next="true"
            ;;
        -*)
            # Any other option, assumed not to take an argument
            skip_next="false"
            ;;
        *)
            if [ "$skip_next" = "true" ]; then
                skip_next="false"
            else
                host="${arg#*@}"
            fi
            ;;
        esac
    done

    set_terminal_title "$host"
    ssh "$@"
    set_terminal_title
}

###########
# Aliases #
###########

alias ln='ln -fi'
alias rm='rm -I'
alias n='nnn -dHerU'
alias ssh='ssh_with_title'

##########
# Prompt #
##########

autoload -Uz promptinit
promptinit
prompt warg

########
# Misc #
########

# Emacs mode
bindkey -e

###########
# Cleanup #
###########

unset _here
