# frozen_string_literal: true

class CreateCategorizations < ActiveRecord::Migration[5.2]
  def change
    create_table :categorizations do |t|
      t.references :category
      t.references :categorizable, polymorphic: true, index: false
      t.timestamps
    end

    add_index :categorizations,
     [:category_id, :categorizable_id, :categorizable_type],
     name: "polymorphic_categorizations",
     unique: true
  end
end
