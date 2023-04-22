# ~/.bashrc: executed by bash(1) for non-login shells.

HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

force_color_prompt=yes

eval "$(starship init bash)"

# alias
alias ll="ls -alF"
alias anime="ani-cli "
alias vi="nvim "


