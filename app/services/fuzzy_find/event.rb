# frozen_string_literal: true

module FuzzyFind
  module Event
    def self.find(needle, attribute: :title, addl_attribute: {})
      ::FuzzyFind::FinderService.call(
        needle:,
        haystack_model: ::Event,
        attribute:,
        addl_attribute:
        )
    end
  end
end
