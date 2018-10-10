# frozen_string_literal: true

require Administrate::Engine.root.join("lib/administrate/field/base")

Administrate::Field::Base.class_eval do

  def html_attributes
    ha = options.fetch(:html_attributes, {})
    ha.merge!(required: true, aria: { required: true }) if required?
    ha
  end

  def public_options
    # By default, options is a protected method.
    # Open ticket at https://github.com/thoughtbot/administrate/issues/1202
    options
  end

  def required?
    validators.any? { |validator| validator.kind_of?(ActiveModel::Validations::PresenceValidator) }
  end

  def admin_only?
    !!options.fetch(:admin_only, false)
  end

  private
    def validators
      resource&.class&.validators_on(attribute) || []
    end
end
