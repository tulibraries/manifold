# frozen_string_literal: true

module FuzzyFind
  module BlogPost
    def self.find(needle, attribute: :title, addl_attribute: {})
      ::FuzzyFind::FinderService.call(
        needle: needle,
        haystack_model: ::BlogPost,
        attribute: attribute,
        addl_attribute: addl_attribute
        )
    end
  end
end
