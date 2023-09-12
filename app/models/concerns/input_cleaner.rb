# frozen_string_literal: true

module InputCleaner
  extend ActiveSupport::Concern

  def normalize_phone_number
    phone_number.gsub!(/\D/, "") if phone_number.present?
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
