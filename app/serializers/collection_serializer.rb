# frozen_string_literal: true

class CollectionSerializer < ApplicationSerializer
  attributes :name, :description, :subject, :contents, :add_to_footer
end
