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
  git clone git://github.com/ry/node.git /tmp/node --depth 10
  cd /tmp/node
  ./configure
  make
  sudo make install
  cd /tmp && rm -rf /tmp/node
}

system_setup () {
  show "System setup, packages"
  apt-get update
  apt-get install -y git zlib1g-dev sudo curl libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev libcurl4-openssl-dev build-essential make libcurl4-openssl-dev libmysqlclient-dev libpq-dev g++ apache2-utils python-software-properties python

  show "Creating user"
  useradd --shell /bin/bash --home-dir $USER_HOME -m -p `openssl passwd strpass` corn
  sudo -u corn ssh-keygen -t rsa -C corn_key@container -f /home/corn/.ssh/id_rsa -q -N ''
  show "Ssh public key :\n`cat /home/corn/.ssh/id_rsa.pub`"

  show "Adding GitHub fingerprint"
  echo "github.com,204.232.175.90 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==" >> /home/corn/.ssh/known_hosts
  chown -R corn:corn /home/corn/.ssh
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
