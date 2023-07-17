# frozen_string_literal: true

FactoryBot.define do
  factory :blog_post do
    title { "Good writings in the blogosphere" }
    content { (0...rand(200)).map { (rand(32...100)).chr }.join }
    publication_date { "2018-09-06 14:57:01" }
    path { "/yup-its-some-good-content" }
    post_guid { "5" }
    categories { "Uncategorized,history news" }
    blog { FactoryBot.build(:blog) }
    content_hash { "12345abcdef" }

    factory :blog_post_exteral_author do
      external_author_name { "Wint Dril" }
    end

    factory :blog_post_assoc_author do
      person { FactoryBot.create(:person) }
    end
  end
end
