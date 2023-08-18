# frozen_string_literal: true

require "administrate/field/base"

class AccountSelectField < Administrate::Field::Select
  def to_s
    data
  end

  def self.permitted_attribute(attribute, _options = nil)
    { attribute.to_sym => [] }
  end

  def permitted_attribute
    self.class.permitted_attribute(attribute)
  end

  def selectable_options
    Account.all.order("name")
  end
end
