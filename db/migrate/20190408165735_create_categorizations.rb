class CreateCategorizations < ActiveRecord::Migration[5.2]
  def change
    create_table :categorizations do |t|
      t.references :category
      t.references :categorizable, polymorphic: true, index: {name: "polymorphic_categorizations"}
      t.timestamps
    end
  end
end
