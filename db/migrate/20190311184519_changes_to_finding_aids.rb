class ChangesToFindingAids < ActiveRecord::Migration[5.2]
  def change
		change_column :finding_aids, :subject, :text
		add_column :finding_aids, :drupal_id, :string
  end
end
