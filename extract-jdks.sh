#!/bin/bash

###############################################################################
#
# Shell script to extract Oracle JDK versions from a download directory to
# a destination directory (containing multiple JDK versions)
#
# Features:
#
# 1. extract multiple versions if not existing in destination directory
# 2. extract sources of JDKS to <destdir>/<jdkdir>/src
# 3. extract API docs to <destdir>/<jdkdir>/docs
#
###############################################################################


[ $# -lt 2 ]  && echo >&2 "USAGE: $0 source-dir destination-dir"   && exit 1
[ ! -d "$1" ] && echo >&2 "[ERROR] source-dir doesn't exists"      && exit 2
[ ! -d "$2" ] && echo >&2 "[ERROR] destination-dir doesn't exists" && exit 3

# remove trailing slashes if any
SRC_DIR=${1%/}
DEST_DIR=${2%/}

for file in "$SRC_DIR"/*-linux-*; do
	echo >&2 "processing [$file] ..."
    fname=${file##*/}
    pre=${fname%-linux-*}
    jnr=${pre:4:1}
    jup=${pre##*u}
	target="$DEST_DIR/jdk1.${jnr}.0_${jup}"

	if [ -d "$target" ]; then
		echo >&2 "[$target] exists. skipping ..."
	else
		echo >&2 "extracting to [$target] ..."
		# in case we are not using GNU tar
		(cd "$DEST_DIR"; tar -xzf -) < "$file"
	fi
done

# extract sources to jdks/<jdkdir>/src
# and api docs to jdks/<jdkdir>/docs
for dir in "$DEST_DIR"/*; do
	SOURCES="$dir/src"
	if [ -d "$SOURCES" ]; then
		echo >&2 "skipping extraction of sources for [$dir] ..."
	else
		echo >&2 "extracting sources to [$SOURCES] ..."
		mkdir "$SOURCES"
		cd "$SOURCES"
		unzip -qq ../src.zip
		cd - > /dev/null
	fi
	APIDOCS="$dir/docs"
	if [ -d "$APIDOCS" ]; then
		echo >&2 "skipping extraction of API docs for [$dir] ..."
	else
		echo >&2 "extracting API docs to [$APIDOCS] ..."
		fname=${dir##*/}
		jnr=${fname:5:1}
		jup=${fname##*_}
		docsfile="jdk-${jnr}u${jup}-docs-all.zip"
		if [ ! -f "$SRC_DIR/$docsfile" ]; then
			echo >&2 "[WARNING] missing API docs file [$SRC_DIR/$docsfile]"
		else
			cp "$SRC_DIR/$docsfile" "$dir"
			cd "$dir"
			unzip -qq "$docsfile"
			rm "$docsfile"
			cd - > /dev/null
		fi
	fi
done
