# frozen_string_literal: true

FactoryBot.define do
  factory :static_redirect, aliases: [:redirect], class: Redirect do
    legacy_path { "/about/hours" }
    manifold_path { "/hours" }
  end

  factory :full_url_redirect, class: Redirect do
    legacy_path { "/srcr/search" }
    manifold_path { "https://librarysearch.temple.edu/scrc" }
  end

  factory :entity_redirect, class: Redirect do
    legacy_path { "/scrc/research/harmful-language" }
    redirectable { FactoryBot.create(:page) }
  end

  factory :collection_redirect, class: Redirect do
    legacy_path { "/collections/blockson" }
    manifold_path { "/blockson" }
  end
end
