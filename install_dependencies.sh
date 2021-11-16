#!/bin/bash

echo "Executing install_dependencies.sh..."

# Run from the specified directory
cd $path_cwd

# Abort if a requirements file doesn't exist
REQ_FILE=$source_code_path/requirements.txt
if [ ! -e $REQ_FILE ]; then
  echo "Error: $REQ_FILE does not exist!"
  exit 1
fi

# Create a temp directory if it doesn't exist
pkg_dir=/tmp/lambda_dist_pkg/
if [ -d $pkg_dir ]; then
  echo "Reusing package staging directory ($pkg_dir)"
else
  echo "Creating package staging directory ($pkg_dir)"
  mkdir $pkg_dir || exit 2
fi

# Create and activate virtual environment...
pip3 install virtualenv
virtualenv -p $runtime env_$function_name || exit 3
source env_$function_name/bin/activate || exit 4

# Installing python dependencies...
echo "Installing dependencies from $REQ_FILE..."
pip install -r "$REQ_FILE" || exit 5

# Deactivate virtual environment...
deactivate

# Create deployment package...
echo "Creating deployment package..."
( cd env_$function_name/lib/$runtime/site-packages/ && cp -r * $pkg_dir) || exit 6

cp -r $source_code_path/* $pkg_dir || exit 7

# Removing virtual environment folder...
echo "Removing virtual environment folder..."
rm -rf env_$function_name

echo "Finished script execution!"
