#!/bin/bash
# Using this file for more than just aliases, in order to leave .bashrc untouched

# Fix screen "Cannot make directory '/run/screen': Permission denied" 
[ ! -e "$HOME/.screen" ] && install -dm 700 "$HOME/.screen"
export SCREENDIR=$HOME/.screen

# Fix gpg "Inappropriate ioctl for device"
export GPG_TTY
GPG_TTY=$(tty)

# Color prompt, designed for vi editing mode (see also .inputrc)
# CAVEATS:
#  - It is very important that Bash detects the exact prompt length, otherwise it will mess up line wrapping.
#  - Non-printing escape sequences should be enclosed in \[ and \], to signal that they do not affect prompt length.
#  - Newline and possibly other special characters may need double-escaping for proper handling, e.g. \\n.
#shellcheck disable=SC2154
PS1='$(
# Preserve exit code
exit=$?;

# Base color, indicating last exit code (red or default)
c="\[$([ $exit -eq 0 ] && echo "\e[0m" || echo "\e[0;91m")\]"

# Current time, white on grey #244
time="\[\e[97;48;5;244m\] $(date +"%Y-%m-%d %H:%M:%S") "

# User, black on green (hostname \h omitted)
user="\[\e[30;42m\] \u "

# AWS profile, black on yellow
awsp="\[\e[30;43m\] awsp:${AWS_PROFILE:-$(sed "s/^\\[\\(.*\\)\\]/\\1/;tb;d;:b;q" ~/.aws/config 2>/dev/null)} "

# Kubectl context, black on blue
kubectl_ctx=$(kubectl config current-context 2>/dev/null)
k8sc="\[\e[30;44m\] k8sc:${kubectl_ctx#*/} "

# Git, white on dark orange: Branch name and status indicator (* = uncommitted changes)
git=$(git branch --show-current 2>/dev/null)
[ $? -eq 0 ] && {
    unset status
    [ ! -z "$(git status -uno --porcelain)" ] && status="*"
    git="$c║\[\e[97;48;5;202m\] git:${git:-(detached)}${status} "
}

# Chroot path, bold, white on light red
chroot="${debian_chroot:+$c┠─┨\[\e[1;97;101m\] $debian_chroot }"

# Working directory, bold, blue
workdir="\[\e[1;34m\]\w"

# PS1 content (putting it all together)
echo "$c┌──┨$time$c║$user$c║$awsp$c║$k8sc$git$chroot$c┠─╼"
echo "$c└──╼ $workdir"
echo "$c$\[\e[0m\] "

# Restore exit code
exit $exit)'
#shellcheck disable=SC2154
PS2='\[\e[7D\e[0$(e=$?;[ $e -ne 0 ] && echo ";91"; exit $e)m    \e[3C\]>\[\e[0m\] '

export PATH=$HOME/.local/bin:${PATH//"$HOME/.local/bin:"/}
export PYTHONDONTWRITEBYTECODE=1

alias ll='ls -alF --time-style=long-iso'
alias ssh-agent-start='[ -e "$HOME/.ssh-agent.env" ] && . "$HOME/.ssh-agent.env"; [ -n "$SSH_AUTH_SOCK" ] && [ -e "$SSH_AUTH_SOCK" ] || { ssh-agent >"$HOME/.ssh-agent.env"; . "$HOME/.ssh-agent.env"; }'
alias sas=ssh-agent-start
alias ssh-agent-stop='eval $(ssh-agent -k); [ -n "$SSH_AUTH_SOCK" ] && rm -f "$SSH_AUTH_SOCK"; rm -f "$HOME/.ssh-agent.env"'
alias sae=ssh-agent-stop
# A trailing space in VALUE causes the next word to be checked for alias substitution when the alias is expanded.
alias xargs='xargs '

which docker >/dev/null && {
    alias dive='docker run --rm -it \
        -v /var/run/docker.sock:/var/run/docker.sock \
        wagoodman/dive:latest'
}
which k9s >/dev/null && \
    alias k9sc='k9s -c ctx'

#shellcheck disable=SC1090
which argo >/dev/null && source <(argo completion bash)
which aws_completer >/dev/null && \
    complete -C "$(which aws_completer)" aws
#shellcheck disable=SC1091
[ -e /usr/share/doc/fzf/examples/key-bindings.bash ] && \
    source /usr/share/doc/fzf/examples/key-bindings.bash
#shellcheck disable=SC1090
which helm >/dev/null && source <(helm completion bash)
#shellcheck disable=SC1090
which kubectl >/dev/null && source <(kubectl completion bash)
#shellcheck disable=SC1090
which pdm >/dev/null && source <(PDM_CHECK_UPDATE=False pdm completion bash)
#shellcheck disable=SC1090
which yq >/dev/null && source <(yq shell-completion bash)
true
