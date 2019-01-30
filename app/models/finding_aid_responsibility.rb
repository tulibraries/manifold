# frozen_string_literal: true

class FindingAidResponsibility < ApplicationRecord
  belongs_to :finding_aid
  belongs_to :person
end
