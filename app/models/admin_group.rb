# frozen_string_literal: true

class AdminGroup < ApplicationRecord
  include AttrJson::Record
  include AttrJson::Record::QueryScopes

  attr_json :managed_entities, :string, array: true, default: []
  validate :valid_managed_entity_types
  validate :managed_entities_uniqueness

  has_many :members, class_name: "Account", dependent: :nullify

  private

    def managed_entities_uniqueness
      managed = managed_entities.select { |me| entity_already_managed?(me) }
      if managed.any?
        errors.add(:managed_entities, "Some Entity Types are already managed: #{managed.join(', ')}")
      end
    end

    def entity_already_managed?(entity_type)
      (AdminGroup.jsonb_contains(managed_entities: entity_type) - [self]).present?
    end

    def valid_managed_entity_types
      unknown_types = managed_entities - manageable_entity_types
      unless unknown_types.empty?
        errors.add(:managed_entities, "Some provided Entity Types are not valid : #{unknown_types.join(', ')}")
      end
    end

    def self.manageable_entity_types
      %w{
        Blog
        Building
        Event
        Exhibition
        ExternalLink
        FormSubmission
        Highlight
        MenuGroup
        Person
        Policy
        Redirect
      }
    end

    def manageable_entity_types
      self.class.manageable_entity_types
    end
end
