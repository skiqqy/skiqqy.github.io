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
	sed -E '/%%BODY%%/d'
}

mkdir -p site
for file in raw/*.txt
do
	case $file in
		*index.txt)
			path=index.html
			;;
		*)
			path=${file/raw/site}
			path=${path/txt/html}
			;;
	esac

	echo "Building $file"
	conv < "$file" > $path
done
