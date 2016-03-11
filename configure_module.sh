#!/bin/bash
#
# This is the main script to configure a module for development. It's
# not intended to be run by the user, another script within a module
# should do it.
#
# Parameters: <module-name>
#
# <module-name> is the name of the module to configure. A module name
# refers to the module Xcode project name and the module main class.
#

set -o errexit
cd "$(dirname "$0")"

# The following two variables must be changed simultaneously
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# The path of the module repository relative the current directory
MODULE_PATH=..
#
# The path of the current directory relative to the module repository
HOST_APP_REL_PATH=ios_hostApp

LIBS_REPO_NAME=ios_libs
LIBS_REPO_URL="https://github.com/aoriens/$LIBS_REPO_NAME.git"
LIBS_PATH="$MODULE_PATH/$LIBS_REPO_NAME"

MODULE_NAME="${1:?Module name must be set in the first parameter}"

if [ ! -e "$LIBS_PATH/.git/HEAD" ]; then
    git clone "$LIBS_REPO_URL" "$LIBS_PATH"
fi

if [ ! -e "$MODULE_PATH/hostApp.xcodeproj" ]; then
    ln -sh "$HOST_APP_REL_PATH/hostApp.xcodeproj" "$MODULE_PATH/hostApp.xcodeproj"
fi
if [ ! -e userContent/config.xml ]; then
    cp -n "$MODULE_PATH/config.xml.sample" userContent/config.xml
fi

sed -e "s/__REPLACE_MODULE_NAME__/$MODULE_NAME/g" -i '' \
    hostApp.xcodeproj/project.pbxproj hostApp/AppConfig.h

echo "
Module '$MODULE_NAME' has been successfully prepared for development.

Now you may open Xcode project 'hostApp.xcodeproj'. This is a dummy
application project to allow easily debug and run your module. See
README.md for additional documentation."
