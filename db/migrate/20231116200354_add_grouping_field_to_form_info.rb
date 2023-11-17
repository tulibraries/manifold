class AddGroupingFieldToFormInfo < ActiveRecord::Migration[7.0]
  def change
    add_column :form_infos, :grouping, :string
  end
end
