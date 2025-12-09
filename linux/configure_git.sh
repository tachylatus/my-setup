#!/bin/sh
set -e

git config --global init.defaultBranch main

git config --global core.excludesfile "${HOME:?}/.gitignore"
git config --global core.autocrlf input

git config --global user.name "Helge Willum Thingvad"
git config --global user.email "1019305+tachylatus@users.noreply.github.com"
git config --global user.signingkey "8454DF309A76CA3A!"

git config --global commit.gpgsign true

git config --global push.default current

git config --global credential.credentialStore cache

git config --global credential.https://github.com.helper "$(which git-credential-manager)"

git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.co checkout
git config --global alias.st status
git config --global alias.sub submodule

# Amend latest commit
git config --global alias.amend 'commit --amend'
# Checkout a new branch
git config --global alias.cb 'checkout -b'
# Produce Markdown changelog e.g. specifying dev..HEAD (or just dev..)
git config --global alias.changelog 'log --pretty=format:"- %s"'
# Show staged changes
git config --global alias.df 'diff --cached'
# Push changes to origin, e.g. prior to creating a merge request
git config --global alias.done 'push origin HEAD'
# Switch to branch and pull changes incl. pruning e.g. after a merge
# shellcheck disable=SC2016
git config --global alias.donedone '!git switch $1 && git pull --ff-only origin $1:$1 && git fetch -ap #'
# Switch to main/master and pull changes incl. pruning e.g. after a merge
# shellcheck disable=SC2016
git config --global alias.donemain '!git switch $(git main) && git pull --ff-only origin $(git main):$(git main) && git fetch -ap'
# Search files in working directory, including untracked, excluding ignored
git config --global alias.gr 'grep --no-index --exclude-standard'
# Display log as a graph
git config --global alias.graph 'log --all --graph --decorate --oneline'
# Display the last log entry of current branch
git config --global alias.last 'log -1 HEAD'
# Determine whether default branch is master or main
# shellcheck disable=SC2016
git config --global alias.main '![ -f "$(git rev-parse --show-toplevel)/.git/refs/heads/master" ] && echo master || echo main'
# Update all submodules
git config --global alias.subup 'submodule update --recursive --remote --init'
# Fetch all changes, prune deleted branches and tags, and pull/update master (fast-forward only)
# shellcheck disable=SC2016
git config --global alias.sync '!git fetch -ap && git pull --ff-only origin $(git main):$(git main)'
# Unstage everything (does not change contents of working directory)
git config --global alias.unstage 'reset HEAD --'

git config -l --show-scope
