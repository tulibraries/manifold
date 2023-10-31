# frozen_string_literal: true

module BuildingsHelper
  def phone_formatted(phone_number = "")
    digits = phone_number.to_s.gsub(/\D/, "")
    if digits.size == 10
      number_to_phone(digits, area_code: true)
    else
      phone_number
    end
  end
  def formatted_address(building)
    "#{building.address1} #{building.city} #{building.state} #{building.zipcode}"
  end
end
