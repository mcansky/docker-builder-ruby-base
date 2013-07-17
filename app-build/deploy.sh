#!/bin/bash
#
# Deploy.sh
#

USER_HOME="/home/corn"
APPDIR="/home/corn/app"
RUBY_VER="1.9.3-p429"
INSIDE_PORT="8080"

show() {
  echo -e "\n\e[1;32m>>> $1\e[00m"
}

system_run () {
  show "."
}

app_setup () {
  system_run
  show "App"

  # get the code
  rm -rf $APPDIR
  sudo -u corn -H -i git clone https://github.com/mcansky/simple_app.git $APPDIR
  sudo -u corn -H -i sh -c "cd $APPDIR && bundle install --deployment --path bundler/"

  # production app settings
  sudo -u corn -H -i echo -e "PORT=$INSIDE_PORT" > $APPDIR/.env
}

app_run () {
  system_run
  show "App start"
  sudo -u corn -H -i sh -c "cd $APPDIR && foreman start"
}

$1