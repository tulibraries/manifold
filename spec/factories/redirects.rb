# frozen_string_literal: true

FactoryBot.define do
  factory :static_redirect, aliases: [:redirect], class: Redirect do
    legacy_path { "/about/hours" }
    manifold_path { "/hours" }
  end

  factory :full_url_redirect, class: Redirect do
    legacy_path { "/scrc/search" }
    manifold_path { "https://librarysearch.temple.edu/scrc" }
  end

  factory :entity_redirect, class: Redirect do
    legacy_path { "/scrc/research/harmful-language" }
    redirectable { FactoryBot.create(:webpage) }
  end

  factory :collection_redirect, class: Redirect do
    legacy_path { "/collections/blockson_collection" }
    manifold_path { "/blockson_collection" }
  end

  factory :category_redirect, class: Redirect do
    legacy_path { "/categories/9" }
    manifold_path { "/blockson_collection" }
  end

  factory :event_redirect, class: Redirect do
    legacy_path { "/events/9" }
    manifold_path { "/blockson_collection" }
  end

  factory :exhibition_redirect, class: Redirect do
    legacy_path { "/exhibitions/9" }
    manifold_path { "/blockson_collection" }
  end

  factory :group_redirect, class: Redirect do
    legacy_path { "/groups/9" }
    manifold_path { "/blockson_collection" }
  end

  factory :highlight_redirect, class: Redirect do
    legacy_path { "/highlights/9" }
    manifold_path { "/blockson_collection" }
  end

  factory :policy_redirect, class: Redirect do
    legacy_path { "/policies/9" }
    manifold_path { "/blockson_collection" }
  end

  factory :service_redirect, class: Redirect do
    legacy_path { "/services/9" }
    manifold_path { "/blockson_collection" }
  end

  factory :space_redirect, class: Redirect do
    legacy_path { "/spaces/9" }
    manifold_path { "/blockson_collection" }
  end
end
