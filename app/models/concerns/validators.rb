# frozen_string_literal: true

module Validators
  extend ActiveSupport::Concern
  class EmailValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
        record.errors.add attribute, (options[:message] || I18n.t("manifold.error.invalid_email"))
      end
    end
  end

  class PhoneNumberValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value =~ /\d{10}/i
        record.errors.add attribute, (options[:message] || I18n.t("manifold.error.invalid_phone_format"))
      end
    end
  end

  class GroupTypeValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless Rails.configuration.group_types.include?(value)
        record.errors.add attribute, (options[:message] || I18n.t("manifold.error.invalid_group_type"))
      end
    end
  end

  class UrlValidator < ActiveModel::EachValidator
    URL_REGEXP = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix
    def validate_each(record, attribute, value)
      unless value =~ URL_REGEXP
        record.errors.add attribute, (options[:message] || I18n.t("manifold.error.invalid_url"))
      end
    end
  end

  class CollectionOrSubjectValidator < ActiveModel::Validator
    def validate(record)
      record.subject.reject! { |s| s.empty? } if record.subject.present?
      record.errors.add :base, "Values for either Collections or Subjects need to be selected." if record.collections.blank? && record.subject.blank?
    end
  end

  class HasRecipientsValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if value.size == 1
        record.errors.add attribute, "field can not be empty." if value.first.blank?
      end
    end
  end
end
