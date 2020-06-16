#!/usr/bin/env bash

dest=${1}.gpg
gpg --cipher-algo aes256 -c -o $dest $1

