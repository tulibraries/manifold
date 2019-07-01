# frozen_string_literal: true

require "rails_helper"

RSpec.describe "persons/index.html.erb", type: :view do

  let (:space) { FactoryBot.create(:space) }
  let (:person) { FactoryBot.create(:person) }

  it "displays the person template" do

    @persons_list = Person.where(id: person.id).page 1
    @person = person
    @locations = [@person.spaces.first.building]
    render
    expect(rendered).to match /Staff Directory/
  end

  it "displays the sample person name" do

    @persons_list = Person.where(id: person.id).page 1
    @person = person
    @locations = [@person.spaces.first.building]
    render
    expect(rendered).to match /#{@persons_list.first.last_name}/
  end
end
