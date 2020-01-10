# frozen_string_literal: true

module InputCleaner
  extend ActiveSupport::Concern

  def normalize_phone_number
    phone_number.gsub!(/\D/, "")
  end
  def sanitize_description
    if self.description.nil?
      self.description = ""
    else
      self.description.gsub!(/<p>\W<\/p>/, "")
      self.description.each_line { |line| line.chomp }
      self.description = ActionController::Base.helpers.sanitize(self.description).strip
    end
  end
  def burpArray
    self.subject.reject! { |s| s.empty? } unless subject.nil?
  end
  def burpSpecialties
    if self.specialties.is_a? Array
      self.specialties.reject! { |s| s.empty? }
    end
  end
end
