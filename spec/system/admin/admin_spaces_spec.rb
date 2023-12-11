# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Spaces", type: :system do
  before do
    login_as(FactoryBot.create(:administrator))
  end

  it_behaves_like "delete restricted", {:space => [:collection, :group, :event, :exhibition]}
end
