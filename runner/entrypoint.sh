#!/usr/bin/env bash

luarocks-5.1 install --tree $ROOTFS/usr/local/share/lua/5.1 sha1

cp -r $SRC/* $ROOTFS/
