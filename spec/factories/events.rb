FactoryBot.define do
  factory :event do
    sequence(:title) { |n| "Event #{n}" }
    description { "MyText" }
    start_time { "2018-09-24 11:32:13" }
    end_time { "2018-09-24 11:32:13" }
    building { nil }
    space { nil }
    external_building { "MyString" }
    external_space { "MyString" }
    external_address { "MyString" }
    external_city { "MyString" }
    external_state { "MyString" }
    external_zip { "MyString" }
    person { nil }
    external_contact_name { "MyString" }
    external_contact_email { "MyString" }
    external_contact_phone { "MyString" }
    cancelled { false }
    registration_status { false }
    registration_link { "MyString" }
    content_hash { "MyString" }
  end
end
