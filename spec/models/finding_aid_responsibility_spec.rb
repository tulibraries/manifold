# frozen_string_literal: true

require "rails_helper"

RSpec.describe FindingAidResponsibility, type: :model do
  describe "Associations" do
    it { should belong_to(:finding_aid) }
    it { should belong_to(:person) }
  end
end
