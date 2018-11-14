# frozen_string_literal: true

class AddHoursFieldToServices < ActiveRecord::Migration[5.2]
  def change
    add_column :services, :hours, :string
  end
end
