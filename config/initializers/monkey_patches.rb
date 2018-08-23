
require Administrate::Engine.root.join('lib/administrate/field/base')

Administrate::Field::Base.class_eval do

  def html_attributes
    ha = options.fetch(:html_attributes, {})
    ha.merge!({required: true, aria: {required: true}}) if required?
    ha

  end

  def public_options
  # By default, options is a protected method.
  # Open ticket at https://github.com/thoughtbot/administrate/issues/1202
    options
  end

  def required?
    !!options.fetch(:required, false)
  end
end
