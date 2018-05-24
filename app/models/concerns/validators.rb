module Validators
  extend ActiveSupport::Concerns
  class EmailValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
        record.errors[attribute] << (options[:message] || "is not an email")
      end
    end
  end

  class PhoneNumberValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value =~ /\d{10}/i
        record.errors[attribute] << (options[:message] || "is not a telephone number")
      end
    end
  end

  class ValidBuildingIdValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if Building.where(id: value).empty?
        record.errors[attribute] << (options[:message] || "reference is invalid") 
      end
    end
  end

  class ValidSpaceIdValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value.nil?
        record.errors[attribute] << (options[:message] || "reference is invalid") if Space.where(id: value).empty? 
      end
    end
  end

  class ValidPersonIdValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value.nil?
        record.errors[attribute] << (options[:message] || "reference is invalid") if Person.where(id: value).empty? 
      end
    end
  end

  class ValidGroupIdValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value.nil?
        record.errors[attribute] << (options[:message] || "reference is invalid") if Group.where(id: value).empty? 
      end
    end
  end

end

