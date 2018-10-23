# frozen_string_literal: true

module FuzzyFind
  module Space
    def self.find(needle, attribute: :name, addl_attribute: {})
      ::FuzzyFind::FinderService.call(
        needle: needle,
        haystack_model: ::Space,
        attribute: attribute,
        addl_attribute: addl_attribute
        )
    end

    def self.by_name_and_building(name:, building:)
      self.call(
        name,
        addl_attribute: { building: building }
        )
    end
  end
end
