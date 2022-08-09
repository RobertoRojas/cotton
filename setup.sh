#!/usr/bin/env bash

set -e;

COTTON_PATH="$HOME/.cotton";
[[ -f $COTTON_PATH ]] && rm $COTTON_PATH && echo 'Removed old cotton file!';
COTTON_REMOTE_FILE="https://raw.githubusercontent.com/RobertoRojas/cotton/main/cotton.sh";
curl -s $COTTON_REMOTE_FILE -o $COTTON_PATH > /dev/null;
echo 'Cotton installed!';