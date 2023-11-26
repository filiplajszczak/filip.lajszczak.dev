#!/bin/sh
haunt build
tar -C site -cvz . > site.tar.gz
hut pages publish -d $site site.tar.gz
