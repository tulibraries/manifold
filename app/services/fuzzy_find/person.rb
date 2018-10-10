# frozen_string_literal: true

module FuzzyFind
  module Person
    def self.find(needle, attribute: :name, addl_attribute: {})
      ::FuzzyFind::FinderService.call(
        needle: needle,
        haystack_model: ::Person,
        attribute: attribute,
        addl_attribute: addl_attribute
        )
    end
  end
end
