#!/bin/bash

###############################################################################
#
# Shell script to automatically download Oracle JDK / JRE / Java binaries from
# the Oracle website using wget
#
# Features:
#
# 1. Resumes a broken / interrupted [previous] download, if any
# 2. Downloads the following distributions:
#    a. Windows 64 bit
#    b. Linux 64 bit
#    c. API Docs
#
###############################################################################

# check for target directory and availability of wget
[ $# -eq 0 ]           && echo >&2 "USAGE: $0 target-directory"             && exit 1
[ ! -d "$1" ]          && echo >&2 "[ERROR] target directory doesn't exist" && exit 2
[ -z "$(which wget)" ] && echo >&2 "[ERROR] requires wget"                  && exit 3

## latest JDK8 version released on 14th July, 2015: JDK8u51
BASE_URL_8=http://download.oracle.com/otn-pub/java/jdk/8u51-b16/jdk-8u51

## previous versions

# BASE_URL_8=http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45
# BASE_URL_8=http://download.oracle.com/otn-pub/java/jdk/8u40-b25/jdk-8u40
# BASE_URL_8=http://download.oracle.com/otn-pub/java/jdk/8u31-b13/jdk-8u31
# BASE_URL_8=http://download.oracle.com/otn-pub/java/jdk/8u25-b17/jdk-8u25

# extract last part of url (== jdk-XuYY)
JDK_VERSION=${BASE_URL_8##*/}

declare -a PLATFORMS=("-windows-x64.exe" "-linux-x64.tar.gz" "-docs-all.zip")

## if you'll need the 32-bit versions, too, use this:
#declare -a PLATFORMS=("-windows-x64.exe" "-linux-x64.tar.gz" "-docs-all.zip" "-windows-i586.exe" "-linux-i586.tar.gz")

# remove trailing slash if any
TARGET_DIR=${1%/}

for platform in "${PLATFORMS[@]}"
do
	wget -c -O "$TARGET_DIR/$JDK_VERSION$platform" --no-check-certificate \
	   --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" "${BASE_URL_8}${platform}"
done
