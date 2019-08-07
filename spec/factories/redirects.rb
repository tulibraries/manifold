# frozen_string_literal: true

FactoryBot.define do
  factory :static_redirect, aliases: [:redirect], class: Redirect do
    legacy_path { "about/hours" }
    manifold_path { "/hours" }
  end

  factory :entity_redirect, class: Redirect do
    legacy_path { "scrc/research/harmful-language" }
    redirectable { FactoryBot.create(:page) }
  end
end
