# frozen_string_literal: true

module BuildingsHelper
  def phone_formatted(phone_number)
    number_to_phone(phone_number, area_code: true)
  end
end
