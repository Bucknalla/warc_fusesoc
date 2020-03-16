#/bin/bash

py_ver=$(python -c 'import platform; major, minor, patch = platform.python_version_tuple(); print(major);')
work_dir=$(pwd)

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

