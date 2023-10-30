# frozen_string_literal: true

class Google::EtextbooksComponent < ViewComponent::Base
  def initialize(etexts:)
    @etexts = etexts&.values
  end
end
