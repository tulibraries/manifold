# frozen_string_literal: true

module SpacesHelper
  def get_phone(space)
    space.phone_number.present? ? phone_formatted(space.phone_number) : phone_formatted(space.building.phone_number)
  end
end
