# frozen_string_literal: true

class CollectionSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :subject, :contents, :add_to_footer
end
