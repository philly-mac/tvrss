#!/bin/bash

cd /var/www/$DEPLOY_DIR
bundle install --deployment --binstubs --without test development
