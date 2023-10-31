# frozen_string_literal: true

namespace :data_migration do
  desc "Migrate space_id from SpaceGroup to Group"

  task migrate_space_id: :environment do
    SpaceGroup.all.each do |space_group|
      group = Group.find_by(id: space_group.group_id)
      group.update(space_id: space_group.space_id) if group
    end
  end
end
