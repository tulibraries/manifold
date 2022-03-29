class AddWeightToFileability < ActiveRecord::Migration[6.1]
  def change
    add_column :fileabilities, :weight, :integer, default: 10
  end
end
