# frozen_string_literal: true

FactoryBot.define do
  factory :library_hour, class: "LibraryHour" do
    location { "" }
    date { Time.zone.now }
    hours { "MyString" }
    location_id { "charles" }
  end
end
