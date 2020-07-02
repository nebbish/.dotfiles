#!/usr/bin/env bash

##
## NOTE:  I just got the idea that this could be encrypting a private GIT archive
##        that ONLY lives in a sub-dir  that is ignored from the ".dotfiles" repo
##
##        then I looked up a 'bare' repo, seems what i want.
##        * To make the initial repo (only once):
##                `git init --bare ~/.dotfiles/private/private.git`
##        * then the 'endot' flow will be:
##            - tar & encrypt the 'bare' archive: ~/.dotfiles/private/private.git.tgz.gpg
##        * and 'dedot' will involve a bit more:
##            - decrypt & untar the 'bare' archive
##            - if local archive exists (~/.dotfiles/private/.git)
##            -     maybe run a 'pull' from the freshly decrypted, maybe updated, shared repo
##            - else
##            -     `git clone` the shared 'bare' repo into this folder as a local repo
##            -     (kinda funny since it is a sub-folder - but it works)
##
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $dir >/dev/null
tar -czf local.tgz .local/
popd >/dev/null
gpg --yes -er nebbish@12esults.com $dir/local.tgz
echo "Created $dir/local.tgz.gpg"
shred -u $dir/local.tgz

