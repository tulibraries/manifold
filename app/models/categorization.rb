class Categorization < ApplicationRecord
  belongs_to :categorization, polymorphic: true
  belongs_to :category
end
