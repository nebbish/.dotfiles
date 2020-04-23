#!/usr/bin/env bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $dir >/dev/null
tar -czf local.tgz .local/
popd >/dev/null
gpg --yes -er nebbish@12esults.com $dir/local.tgz
echo "Created $dir/local.tgz.gpg"
shred -u $dir/local.tgz

