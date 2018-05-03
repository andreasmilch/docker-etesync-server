#!/bin/bash

declare -r -a ALPINE_TAGS=(alpine3.6 alpine3.7)
declare -r -a DEBIAN_TAGS=(latest slim stretch slim-stretch)


function generate() {
	local -r TYPE=$1
	shift
	local -ra TAGS=("$@")
	
	for tag in ${TAGS[*]}; do
		echo "Generating build context for $tag"
		mkdir -p $TYPE/$tag
		cp -f confs/* $TYPE/$tag/
		sed -r "s!%%PYTHON_TAG%%!$tag!g;" Dockerfile_$TYPE.template > $TYPE/$tag/Dockerfile
	done	
}

rm -r --interactive=never debian alpine

generate alpine "${ALPINE_TAGS[@]}"
generate debian "${DEBIAN_TAGS[@]}"
