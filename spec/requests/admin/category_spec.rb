# frozen_string_literal: true

require "rails_helper"

RSpec.describe Category, type: :request do

  it_behaves_like "renderable_dashboard"
  it_behaves_like "detachable"

end
