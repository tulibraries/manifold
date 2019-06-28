#!/bin/bash
set -e

cd ..
# clone deployment playbook
git clone --single-branch --branch qa git@github.com:tulibraries/ansible-playbook-manifold.git
cd tul_cob_playbook
# install playbook requirements
sudo pip install pipenv
# install playbook requirements
pipenv install
# install playbook role requirements
pipenv run ansible-galaxy install -r requirements.yml
# setup vault password retrieval from travis envvar
cp .circleci/.vault ~/.vault
# setup vault password retrieval from travis envvar
chmod +x ~/.vault

# deploy to qa using ansible-playbook
pipenv run ansible-playbook -i inventory/new-qa/hosts playbook.yml --vault-password-file=~/.vault --private-key=~/.ssh/.conan_the_deployer
