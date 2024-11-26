#!/usr/bin/env bash

rm -rf rd/*
ramdisk delete $(mount | ag ramdisk | awk '{print $1}' | tail -1)
rm rd
