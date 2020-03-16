#/bin/bash

py_ver=$(python -c 'import platform; major, minor, patch = platform.python_version_tuple(); print(major);')
work_dir=$(pwd)

function parse_yaml {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}


echo "Install Fusesoc..."

if ! [ "$py_ver" = "3" ]; then
  echo "Requires Python 3."
  exit 1
fi

if result=$(pip install fusesoc) ; then
    echo "Fusesoc installed."
    # sed -i "2s|.*|location = $work_dir|" fusesoc.conf
    fusesoc library add warc $(pwd)
else
    echo "Fusesoc installation failed. Check permissions."
fi

