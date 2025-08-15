# frozen_string_literal: true

class AssignNoGroupingToBlankFormInfos < ActiveRecord::Migration[7.2]
  def up
    FormInfo.where(grouping: [nil, ""]).find_each do |form_info|
      form_info.update!(grouping: "No Grouping")
    end
  end

  def down
    FormInfo.where(grouping: "No Grouping").find_each do |form_info|
      form_info.update!(grouping: nil)
    end
  end
end
