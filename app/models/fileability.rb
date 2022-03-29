# frozen_string_literal: true

class Fileability < ApplicationRecord
  belongs_to :attachable, polymorphic: true
  belongs_to :file_upload

  validates :weight, presence: true
end
