#!/bin/bash

set -e
set -x

DIR=$(dirname "${BASH_SOURCE[0]}")
source $DIR/../env.sh

PKG=$(get_pkg deb)
DEB_LIST=$DIR/dvc.list
AWS_S3_PREFIX=deb

upload_file $DEB_LIST $AWS_S3_PREFIX

deb-s3 upload --bucket $AWS_S3_BUCKET \
              --prefix $AWS_S3_PREFIX \
              --preserve-versions \
              --arch amd64 \
              --codename stable \
              --access-key-id $(get_conf aws_access_key_id) \
              --secret-access-key $(get_conf aws_secret_access_key) \
              --s3-region $(get_conf region) \
              $PKG

cp $DEB_LIST /etc/apt/sources.list.d/
apt-get update
apt-get install dvc
dvc --help
