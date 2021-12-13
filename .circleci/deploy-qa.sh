#!/bin/bash
set -e

cd ..
# clone deployment playbook
git clone --single-branch --branch qa git@github.com:tulibraries/ansible-playbook-manifold.git
cd ansible-playbook-manifold
# install playbook requirements
pipenv install
# install playbook role requirements
pipenv run ansible-galaxy install -r requirements.yml
# setup vault password retrieval from travis envvar
cp .circleci/.vault ~/.vault
# setup vault password retrieval from travis envvar
chmod +x ~/.vault

# deploy to qa using ansible-playbook
echo "Running: pipenv run ansible-playbook -i inventory/qa playbook.yml --vault-password-file=~/.vault"
pipenv run ansible-playbook -i inventory/qa playbook.yml --vault-password-file=~/.vault
