#!/usr/bin/env bash

set -e;

COTTON_PATH="$HOME/.cotton";
BASH_PROFILE_PATH="$HOME/.bash_profile";
COTTON_REMOTE_FILE="https://raw.githubusercontent.com/RobertoRojas/cotton/v1.0/cotton.sh";
[[ -f $COTTON_PATH ]] && rm $COTTON_PATH && echo 'Cotton deleted!';
curl -s $COTTON_REMOTE_FILE -o $COTTON_PATH > /dev/null;
echo 'Cotton download!';
[[ ! -f $BASH_PROFILE_PATH ]] && touch $BASH_PROFILE_PATH;
[ -z "$(cat ~/.bash_profile | grep "source $COTTON_PATH")" ] && echo -e "\n#Cotton section\n\nsource $COTTON_PATH" >> $BASH_PROFILE_PATH && echo 'Cotton added!';
unset COTTON_PATH;
unset BASH_PROFILE_PATH;
unset COTTON_REMOTE_FILE;