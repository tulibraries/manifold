# frozen_string_literal: true

class CollectionAid < ApplicationRecord
  belongs_to :collection
  belongs_to :finding_aid
end
