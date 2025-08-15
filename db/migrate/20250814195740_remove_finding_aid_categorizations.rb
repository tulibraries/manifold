# frozen_string_literal: true

class RemoveFindingAidCategorizations < ActiveRecord::Migration[7.2]
  def up
    Categorization.where(categorizable_type: "FindingAid").delete_all
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Cannot restore FindingAid categorizations after FindingAid model removal"
  end
end
