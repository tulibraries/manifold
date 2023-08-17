# frozen_string_literal: true

require "administrate/field/base"

class AccountSelectField < Administrate::Field::Select
  def to_s
    data
  end

  def selectable_options
    Account.all.order("name")
  end
end
