#!/usr/bin/env bash
# Loads older dumpfile to get around missing dependencies in most recent migrations
# As of 1/10/2020
# Delete this file when we have a current dumpfile
# To Run from Rails root:
# . ./bin/migrate_from_outdated_dumpfile.sh
#
git checkout -- db
git checkout master
rm db/migrate/20191209174001_rename_page_web_page.rb
rm db/migrate/20191210182110_update_category_associations_for_all_models.rb
sed -i -e 's/webpages/pages/' db/schema.rb
bx rails db:drop DISABLE_DATABASE_ENVIRONMENT_CHECK=1
bx rails db:setup
sudo su postgres -c "pg_restore -c --dbname=manifold_development ./postgres_dump_file.sqlc"
git checkout -- db/migrate
bx rails db:migrate
git checkout draft_entities
