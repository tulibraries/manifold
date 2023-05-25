# frozen_string_literal: true

module FuzzyFind::FinderService
  require "fuzzy_match"

  class Error < StandardError; end

  # FuzzyFinderService takes a string tries to find the best match
  # for that string in the attribute (name by default) of a given model.
  # For example FuzzyFinderService.call(needle: "Joe Schmoe", haystack_model: Person)
  #  will return the Person object for "Joseph Schmoe".
  # or using another attribute
  # FuzzyFinderService.call(needle: "joe@schmoe.com", haystack_model: Person, attribute: :email_address)
  # It is useful when you want to connect data coming from external systems
  # to records in the DB.
  # You can also filter further with additional paramters
  # Say you know the group the person is in as well, to help disambiguate
  # g = Group.find_by(name: "Piano Players")
  # Pass that group along with the association attribute for the Person mode as addl_attribute
  # p = FuzzyFinderService.call(needle: "Jon Smith", haystack_model: Person, addl_attribute: {groups: g })
  # p.name
  # > "Jon Smith"
  # p.groups
  # > [#<Group:0x00007fb560170690, id: 1, name: "Piano Players",...]
  #
  # @param needle [String] the string you want to match, `Joe Schmoe`
  # @param haystack_model [Class] the model to search against,`Person`
  # @param attribute [String, Symbol] model attribute to match against.
  #   Association attributes will not work, `email_address`
  # @param addl_attribute [Hash]  Additional attribute and value to filter by.
  #   Can include Associations. `{groups: groupObject }` or `{groups}`
  # @option addl_attribute [Object, String, Integer] :attribute_
  # @return [String] the object converted into the expected format.
  def self.call(needle: , haystack_model:, attribute: :name, addl_attribute: {})
    Finder.new(haystack_model:, attribute:, addl_attribute:)
      .find(needle)
  end

  class Finder
    def initialize(haystack_model:, attribute: nil, addl_attribute: {})
      @model = ensure_is_a_class_name(haystack_model)
      validate_is_a_defined_active_model!
      @attribute = attribute
      @addl_attribute = format_addl_attribute(addl_attribute)
    end

    delegate :find, to: :matcher

    private
      attr_reader :model, :attribute, :addl_attribute

      def ensure_is_a_class_name(model)
        model.is_a?(Class) ? model : model.to_s.classify.constantize
      end

      def validate_is_a_defined_active_model!
        #Eager load classes if not in production (is already
        # done in production) so ApplicationRecord.descendants works
        Rails.application.eager_load! unless Rails.env.production?
        raise Error.new(
          "#{model} is not an ActiveModel in this application"
        ) unless ApplicationRecord.descendants.include? model
      end

      def model_query
        if attribute_is_has_many_through?(addl_attribute)
          model.joins(addl_attribute.key).where(addl_attribute.key => { id: pick_addl_attribute_value })
        else
          model.where(addl_attribute.to_h)
        end
      end

      def format_addl_attribute(addl_attribute)
        return addl_attribute if addl_attribute.empty?
        AddlAttribute.new([:key, :value].zip(addl_attribute.first).to_h)
      end

      def pick_addl_attribute_value
        # If the value is an object, grab the id, otherwise return the value
        addl_attribute.value.respond_to?(:model_name) ? addl_attribute.value.id : addl_attribute.value
      end

      def attribute_is_has_many_through?(attribute)
        return false if attribute.is_a? Hash
        # this returns nil if the attribute is not an association
        model.reflect_on_association(attribute.key)
          &.association_class == ActiveRecord::Associations::HasManyThroughAssociation
      end

      def options
        {
          must_match_at_least_one_word: true,
          read: attribute.to_sym
        }
      end

      def matcher
        @matcher ||= FuzzyMatch.new(model_query, options)
      end

      class AddlAttribute < OpenStruct
        def to_h
          { key => value }
        end
      end
  end
end
