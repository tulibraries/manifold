# frozen_string_literal: true

class Google::EtextbooksComponent < ViewComponent::Base
  delegate :librarysearch_url, to: :helpers

  def initialize(etexts:)
    @etexts = etexts.values
  end
  def catalog_link(id, title)
    link_to(title, "#{librarysearch_url("catalog")}/#{id}")
  end
end
