class ChangeBuildingToSpaceOnCollectionsModel < ActiveRecord::Migration[5.2]
  def change
  	change_table :collections do |t|
	  	t.references :space, foreign_key: true
	  end
  end
end
