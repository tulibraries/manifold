class AddCustomTextToAlertLink < ActiveRecord::Migration[8.1]
  def change
    add_column :alerts, :link_text, :string
  end
end
