#!/usr/bin/env bash

dest=${1%.gpg}
gpg -o $dest -d $1

