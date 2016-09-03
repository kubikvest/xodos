#!/usr/bin/env bash

luarocks-5.1 install --tree $ROOTFS/usr/local sha1

cp -r $SRC/* $ROOTFS/
mkdir -p $ROOTFS/app/logs
mkdir -p $ROOTFS/run/nginx
