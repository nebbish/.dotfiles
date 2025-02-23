#!/usr/bin/env bash

if [[ $# == 0 ]]; then
    echo "Current setting:  $(osascript -e 'tell app "System Events" to tell appearance preferences to get dark mode')"
    return 2>/dev/null || exit
fi

if [[ ${1} == 'true' ]]; then
    echo "enabling dark mode..."
    osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to true'
elif [[ ${1} == 'false' ]]; then
    echo "disabling dark mode..."
    osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to false'
elif [[ ${1} == 'dark' ]]; then
    echo "setting dark mode..."
    osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to true'
elif [[ ${1} == 'light' ]]; then
    echo "setting ligt mode..."
    osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to false'
elif [[ ${1} == 'toggle' ]]; then
    echo "toggling dark/ligt mode..."
    osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to not dark mode'
else
    echo "Unknown command, [$1].  Exiting without doing anything"
    exit -1
fi

