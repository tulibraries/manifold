# frozen_string_literal: true

module FindingAidsFinder
  extend ActiveSupport::Concern

  def has_finding_aids(collection)
    number_of_aids(collection) != 0
  end

  def number_of_aids(id)
    FindingAid.where(collection_id: id).count
  end
end
