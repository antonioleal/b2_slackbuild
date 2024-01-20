#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $SCRIPT_DIR

set -e

cd ..
PKGNAME=${PWD##*/}
echo "Package: " $PKGNAME
cd ..
CATEGORY=${PWD##*/}
echo "Category: " $CATEGORY

read -p "Commit message: " MSG
echo
echo

cd ~/slackware-builds/antonioleal/slackbuilds
git checkout -B $PKGNAME
cd ~/slackware-builds/antonioleal/slackbuilds/$CATEGORY/
echo
echo

tar xvfz ~/slackware-builds/antonioleal/myslackbuilds/$CATEGORY/$PKGNAME/updater/slackbuild/$PKGNAME.tar.gz
echo
echo

# spawn pull-request console and show follow-up commands (I prefer to do this manually)
#konsole -e /bin/bash --rcfile <(echo "cd ~/slackware-builds/antonioleal/slackbuilds/$CATEGORY/$PKGNAME ; pwd ; echo ; ls --color ; echo ; git status") &

pwd
git status

# git commit -a -m "$CATEGORY/$PKGNAME: $MSG"
echo
echo git commit -a -m "\"$CATEGORY/$PKGNAME: $MSG\""
read -p "Issue command above? (y/n) " op
if [ "$op" = "y" ] || [ "$op" = "Y" ]; then
    echo "BOMBA"
    #git commit -a -m "$CATEGORY/$PKGNAME: $MSG"
fi

echo git push -f origin $PKGNAME
echo git checkout master

#echo git branch -D $PKG
# delete all branches
#git branch | grep -v "master" | xargs git branch -D
echo 'git branch | grep -v "master" | xargs git branch -D'


# manual clean-up: git checkout master && git branch -D timeshift && git reset --hard && git branch && git status
