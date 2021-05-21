#!/bin/bash

echo "Executing install_dependencies.sh..."

# Abort if a requierements file doesn't exist
FILE=$source_code_path/requirements.txt
if [ ! -e $FILE ]; then
  echo "Error: $FILE does not exist!"
  exit 1
fi

# Run from the specified directory
cd $path_cwd

# Create a temp directory if it doesn't exist
dir_name=/tmp/lambda_dist_pkg/
if [ -d $dir_name ];
  echo "Reusing package staging directory ($dir_name)"
else
  echo "Creating package staging directory ($dir_name)"
  mkdir $dir_name || exit 2

# Create and activate virtual environment...
virtualenv -p $runtime env_$function_name || exit 3
source env_$function_name/bin/activate || exit 4

# Installing python dependencies...
echo "Installing dependencies from $FILE..."
pip install -r "$FILE" || exit 5

# Deactivate virtual environment...
deactivate

# Create deployment package...
echo "Creating deployment package..."
( cd env_$function_name/lib/$runtime/site-packages/ && cp -r * $dir_name) || exit 6

cp -r $source_code_path/ $dir_name || exit 7

# Removing virtual environment folder...
echo "Removing virtual environment folder..."
rm -rf env_$function_name

echo "Finished script execution!"
