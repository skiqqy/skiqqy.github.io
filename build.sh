#!/bin/bash
# Auther: Skiqqy

HOST="https://github.com/"

conv () {
	# Take a file and convert it to html by making substitutes.

	# ^/name -> https://github.com/name
	# */name.domain -> https://name.domain
	# !/name.domain -> http://name.domain
	sed -E "s|(\\^/)([^ \)]*)|^\/<a href=$HOST/\2>\2</a>|g" |
	sed -E "s|(\\*/)([^ \)]*)|*\/<a href=https:\/\/\2/>\2</a>|g" |
	sed -E "s|(\\!/)([^ \)]*)|!\/<a href=http:\/\/\2/>\2</a>|g" |

	sed -E '/%%BODY%%/r /dev/stdin' raw/template.html |
	sed -E '/%%BODY%%/d' |
	sed 's/%%HEADER%%/'"$header"'/g'
}

main () {
	while getopts "d" opt
	do
		case $opt in
			d)
				dev="<h4 class=dev>Please note, this is the development page, things may be broken\.<\/h4><details><summary>Details<\/summary>This version of my website is hosted inside a docker container and pulls from origin\/dev every 10 seconds, hence it is possible for the site to be unstable, this is only for demo purposes\.<\/details>"
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
				header="<h1>$(echo $file | cut -d "/" -f 2 | cut -d "." -f 1)<\/h1>"
				path=${file/raw/site}
				path=${path/txt/html}
				;;
		esac
		[[ -n $dev ]] && header="$header$dev"

		echo "Building $file"
		conv < "$file" > $path
	done
}

main "$@"
