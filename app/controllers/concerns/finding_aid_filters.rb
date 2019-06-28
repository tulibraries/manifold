# frozen_string_literal: true

module FindingAidFilters
  extend ActiveSupport::Concern

  def collections_list(finding_aids)
    to_add = finding_aids.select { |aid| aid.collections.any? { |collection| collection.id.to_s == params[:collection] } }

    collections = []

    to_add.each do |aid|
      collections << aid
    end

    collections
  end

  def subjects_list(finding_aids)
    to_add = finding_aids.select { |aid| aid.subject.any? { |subject| params[:subject].split(",").include?(subject) } }

    subjects = []

    to_add.each do |aid|
      subjects << aid
    end

    subjects
  end
end
