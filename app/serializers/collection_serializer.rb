# frozen_string_literal: true

class CollectionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :subject, :contents, :add_to_footer, :label, :updated_at
end
