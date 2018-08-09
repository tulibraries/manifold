FactoryBot.define do
  factory :person do
    first_name "Zaphod"
    last_name "Beeblebrox"
    phone_number "2155551213"
    email_address "zbeeblebrox@example.com"
    chat_handle "zbeeblebrox"
    job_title "President of the Galaxy"
    research_identifier "PREZBEEB"
    # Add related objects in create.
    # e.g.
    #   let(:building) { FactoryBot.create(:building) }
    #   let(:space) { FactoryBot.create(:space, building: building) }
    #   let(:person) { FactoryBot.create(:person, spaces: [space]) }
  end
end
