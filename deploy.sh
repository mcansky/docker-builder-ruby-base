#!/bin/bash
#
# Deploy.sh
#

USER_HOME="/home/corn"
APPDIR="/home/corn/app"
RUBY_VER="1.9.3-p429"

show() {
  echo -e "\n\e[1;32m>>> $1\e[00m"
}

node_install () {
  show "Installing node.js"
  git clone git://github.com/ry/node.git /tmp/node
  cd /tmp/node
  ./configure
  make
  sudo make install
  cd /tmp && rm -rf /tmp/node
}

system_setup () {
  show "System setup, packages"
  apt-get update
  apt-get install -y git zlib1g-dev sudo curl libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev libcurl4-openssl-dev build-essential make libcurl4-openssl-dev libmysqlclient-dev libpq-dev g++ apache2-utils

  show "Creating user"
  useradd --shell /bin/bash --home-dir $USER_HOME -m -p `openssl passwd strpass` corn
}


rbenv_setup () {
  show "Rbenv setup"
  git clone https://github.com/sstephenson/rbenv.git /home/corn/.rbenv
  git clone https://github.com/sstephenson/ruby-build.git /home/corn/.rbenv/plugins/ruby-build
  chown -R corn:corn /home/corn/.rbenv
}

profile_setup () {
  echo 'export RBENV_ROOT=/home/corn/.rbenv' >> /home/corn/.profile
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/corn/.profile
  echo 'eval "$(rbenv init -)"' >> /home/corn/.profile
  chown -R corn:corn /home/corn/.profile
}

ruby_build () {
  show "Building ruby"
  sudo -u corn -H -i rbenv install $RUBY_VER
  sudo -u corn -H -i rbenv local $RUBY_VER
  sudo -u corn -H -i gem install bundler rake foreman --no-rdoc --no-ri
}

system_run () {
  show "."
}

$1
