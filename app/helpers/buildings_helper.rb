# frozen_string_literal: true

module BuildingsHelper
  def phone_formatted
    number_to_phone(@building.phone_number, area_code: true)
  end
end
