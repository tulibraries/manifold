class AddEnabledToFormInfo < ActiveRecord::Migration[7.0]
  def change
    add_column :form_infos, :enabled, :boolean, default: true
  end
end
