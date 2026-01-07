# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    sequence(:email) { |n| "#{(0...3).map { (65 + rand(26)).chr }.join}000#{n}@temple.edu" }
    password { "MyPassword" }
    sequence(:name) { |n| "My Name #{n}" }
    role { "regular" }

    # Traits for AdminGroup memberships - creates the group if needed
    trait :library_administration do
      after(:create) do |account|
        group = FactoryBot.create(:admin_group,
          name: "Library Administration",
          managed_entities: ["Blog", "Building", "Person", "Policy"])
        account.update!(admin_group: group)
      end
    end

    trait :library_communication do
      after(:create) do |account|
        group = FactoryBot.create(:admin_group,
          name: "Library Communication",
          managed_entities: ["Event", "Exhibition", "Highlight"])
        account.update!(admin_group: group)
      end
    end

    trait :website_administration do
      after(:create) do |account|
        group = FactoryBot.create(:admin_group,
          name: "Website Administration Group",
          managed_entities: ["ExternalLink", "Redirect"])
        account.update!(admin_group: group)
      end
    end

    trait :form_submissions_admin do
      after(:create) do |account|
        group = FactoryBot.create(:admin_group,
          name: "Form Submissions Admin",
          managed_entities: ["FormSubmission"])
        account.update!(admin_group: group)
      end
    end

    trait :special_collections do
      after(:create) do |account|
        group = FactoryBot.create(:admin_group,
          name: "Special Collections Research Center",
          managed_entities: ["MenuGroup"])
        account.update!(admin_group: group)
      end
    end

    trait :student do
      role { "student" }
    end
  end

  factory :administrator, class: Account do
    sequence(:email) { |n| "#{(0...3).map { (65 + rand(26)).chr }.join}admin#{n}@temple.edu" }
    password { "MyPassword" }
    sequence(:name) { |n| "My Name #{n}" }
    role { "admin" }
  end
end
