# frozen_string_literal: true

class ExternalLinkWebpage < ApplicationRecord
  belongs_to :webpage
  belongs_to :external_link
end
