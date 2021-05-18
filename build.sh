#!/bin/bash
# Auther: Skiqqy

HOST="https://github.com/"
quote=true # True injects a qoute in hex

# Find a (WIP) qoute and transform to hex, replaceing newlines with \n
quote ()
{
	if "$quote"
	then
		res=$(printf 'C is quirky, flawed, and an enormous success.\n Dennis M. Ritchie' |
			hexdump -e '8/1 " %02X" "\n"')
		printf '%s' "${res//$'\n'/\\n}"
	fi
}

conv () {
	# Take a file and convert it to html by making substitutes.

	# ^/name -> https://github.com/name
	# */name.domain -> https://name.domain
	# _/name.domain -> http://name.domain
	# a/name.domain/title/ -> <a href="name.domain">title</a>

	sed -E "s|(\\^/)([^ \)]*)|^\/<a href=$HOST/\2>\2</a>|g" |
	sed -E "s|(\\*/)([^ \)]*)|*\/<a href=https:\/\/\2/>\2</a>|g" |
	sed -E "s|(\\_/)([^ \)]*)|_\/<a href=http:\/\/\2/>\2</a>|g" |
	sed -E 's|a/(.+)/(.+)/|<a href="\1">\2</a>|g' |
	sed -E 's|^SBLOCK\. (.+)|<div class=box><div class=boxheader>\1</div><br>|g' |
	sed -E 's|^EBLOCK\.|</div>|g' |
	sed -E 's|\\\\|<br>|g' |
	sed -E 's|WIP\.|<center><img style="width: 150px"src=../assets/con.gif><center>|g' |
	sed -E 's|WIP\\\.|WIP.|g' |

	sed -E '/%%BODY%%/r /dev/stdin' raw/template.html |
	sed -E '/%%BODY%%/d' |
	sed -E "s|%%QUOTE%%|$(quote)|g" |
	sed -E "s|%%DEV%%|$dev|g" |
	sed 's/%%HEADER%%/'"$header"'/g'
}

main () {
	while getopts "dqw" opt
	do
		case $opt in
			d)
				dev="<h4 class=dev>Please note, this is the development page, things may be broken\.<\/h4><h4 class=dev>Last built on $(date)\.<\/h4><details><summary>Details<\/summary>This version of my website is hosted inside a <a href=https:\/\/github.com\/skiqqy\/skiqqy-docker>docker container<\/a> and pulls from origin\/dev every 1 minute, hence it is possible for the site to be unstable, this is only for demo purposes\.<\/details>"
				;;
			q)
				quote=false
				;;
			*)
				exit 2
				;;
		esac
	done

	mkdir -p site
	for file in raw/*.txt
	do
		case $file in
			*index.txt)
				path=index.html
				header="<h1>Skiqqy<\/h1>~ Pronounced skippy"
				;;
			*)
				header="<h1>$(echo "$file" | cut -d "/" -f 2 | cut -d "." -f 1)<\/h1>"
				path=${file/raw/site}
				path=${path/txt/html}
				;;
		esac
		#[[ -n $dev ]] && header="$header$dev"

		echo "Building $file"
		conv < "$file" > "$path"
	done
}

main "$@"
