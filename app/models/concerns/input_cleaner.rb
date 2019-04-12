# frozen_string_literal: true

module InputCleaner
  extend ActiveSupport::Concern

  def normalize_phone_number
    phone_number.gsub!(/\D/, "")
  end
  def sanitize_description
    self.description.gsub!(/<p>\W<\/p>/, "")
    self.description.each_line { |line| line.chomp }
    self.description = ActionController::Base.helpers.sanitize(self.description).strip
  end
  def burpArray
    self.subject.reject! { |s| s.empty? }
  end
end
