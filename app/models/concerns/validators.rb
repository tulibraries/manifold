# frozen_string_literal: true

module Validators
  extend ActiveSupport::Concerns
  class EmailValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value.blank?
        unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
          record.errors[attribute] << (options[:message] || I18n.t("fortytude.error.invalid_email"))
        end
      end
    end
  end

  class PhoneNumberValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value.blank?
        unless value =~ /\d{10}/i
          record.errors[attribute] << (options[:message] || I18n.t("fortytude.error.invalid_phone_format"))
        end
      end
    end
  end

  class GroupTypeValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless Rails.configuration.group_types.include?(value)
        record.errors[attribute] << (options[:message] || I18n.t("fortytude.error.invalid_group_type"))
      end
    end
  end

  class UrlValidator < ActiveModel::EachValidator
    URL_REGEXP = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix
    def validate_each(record, attribute, value)
      unless value =~ URL_REGEXP
        record.errors[attribute] << (options[:message] || I18n.t("fortytude.error.invalid_url"))
      end
    end
  end
end
