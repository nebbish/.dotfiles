#!/usr/bin/env bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
gpg --yes -do $dir/local.tgz $dir/local.tgz.gpg
tar -xzf $dir/local.tgz -C $dir
shred -u $dir/local.tgz

