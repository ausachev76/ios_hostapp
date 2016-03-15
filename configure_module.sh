#!/bin/bash
#
# This is the main script to configure a module for development. It's
# not intended to be run by the user, another script within a module
# project directory should do it.
#
# Parameters: none
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
LIBS_REPO_URL="git@office.solovathost.com:ios/$LIBS_REPO_NAME.git"
LIBS_PATH="$MODULE_PATH/$LIBS_REPO_NAME"

die() {
    echo "$@" 1>&2
    exit 1
}

# Returns the module name or exits
determineModuleName() {
    local xcodeProjects=$(
        find "$MODULE_PATH" -name '*.xcodeproj' -not -name 'hostApp.xcodeproj' -depth 1 -type d |
            while read LINE; do
                echo "$(basename "$LINE")"
            done
          )

    local projectPath=$(
        # It's executed in a subshell to isolate variable PS3 and IFS
        # changes
        (
            if [ "$(wc -l <<< "$xcodeProjects")" -lt 2 ]; then
                # If one module or no modules found, use the found
                # xcodeProjects string
                echo "$xcodeProjects"
            else
                # Otherwise allow the user to choose a module project
                # manually
                PS3="Several Xcode projects have been found, which one is to be configured as the module? "
                IFS=$'\n'
                local p=
                select p in $xcodeProjects; do
                    [ -n "$p" ] && break
                done

                # User can close stdin here, so p may be empty
                echo "$p"
            fi
        ))

    if [ -z "$projectPath" -o ! -d "$MODULE_PATH/$projectPath" ]; then
        die "No modules found"
    fi

    # Cut off '.xcodeproj' suffix
    echo "${projectPath%.xcodeproj}"
}

MODULE_NAME="$(determineModuleName)"

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
