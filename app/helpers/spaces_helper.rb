# frozen_string_literal: true

module SpacesHelper
  def phone_formatted(num)
    number_to_phone(num, area_code: true)
  end
end
