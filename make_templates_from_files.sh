#!/bin/bash
#
# Make template files from specific sources and project files. Run the
# script before every time you are going to commit changes within
# hostapp project.
#
# Parameters: none.
#
# If you consider using the script, DO NOT MODIFY TEMPLATE FILES BY
# HAND. The script overwrites them entirely.
#
# The script writes some modified files (including the Xcode project
# file) back to template files with reverse string replacement. This
# is necessary if you have done modifications in the files and wish to
# save them in the corresponding template files.
#
# See README.md for additional information.
#

MODULE_NAME="$(./configure_module.sh --get-module-name)"

# Make a template file from file $1 with replacing module name $2 with
# some substring within the file
makeTemplateFromFile() {
    sed -e "s/$2/__REPLACE_MODULE_NAME__/g" "$1" > "$1.template"
}

makeTemplateFromFile hostApp.xcodeproj/project.pbxproj "$MODULE_NAME"
makeTemplateFromFile hostApp/AppConfig.h "$MODULE_NAME"
