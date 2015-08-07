#!/bin/bash
set -exuo pipefail

# TODO delete boilerplate
# This script is run in the VM once when you first run `vagrant-spk up`.  It is
# useful for installing system-global dependencies.  It is run exactly once
# over the lifetime of the VM.
#
# This is the ideal place to do things like:
#
#    export DEBIAN_FRONTEND=noninteractive
#    apt-get install -y nginx nodejs nodejs-legacy python2.7 mysql-server
#
# If the packages you're installing here need some configuration adjustments,
# this is also a good place to do that:
#
#    sed --in-place='' \
#            --expression 's/^user www-data/#user www-data/' \
#            --expression 's#^pid /run/nginx.pid#pid /var/run/nginx.pid#' \
#            --expression 's/^\s*error_log.*/error_log stderr;/' \
#            --expression 's/^\s*access_log.*/access_log off;/' \
#            /etc/nginx/nginx.conf

# By default, this script does nothing.  You'll have to modify it as
# appropriate for your application.


export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y \
  openjdk-7-jre-headless \
  exuberant-ctags \
  git \
  subversion \
  mercurial \
  tomcat7 \
  tomcat7-user \
  wget

service tomcat7 stop
systemctl disable tomcat7

# woof https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=435293



## OpenGrok will use tomcat as a servlet container; let's
## configure tomcat now.
#ised --in-place='' \
#  --expression='s/port="8080"/port="8000"/' \
#  /etc/tomcat7/server.xml
#    # Sandstorm expects port 8000, Tomcat defaults to 8080

