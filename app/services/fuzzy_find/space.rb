# frozen_string_literal: true

module FuzzyFind
  module Space
    def self.find(needle, attribute: :name, addl_attribute: {})
      ::FuzzyFind::FinderService.call(
        needle:,
        haystack_model: ::Space,
        attribute:,
        addl_attribute:
        )
    end

    def self.by_name_and_building(name:, building:)
      self.call(
        name,
        addl_attribute: { building: }
        )
    end
  end
end
