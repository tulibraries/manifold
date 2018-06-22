require 'rails_helper'

RSpec.describe "persons/show.html.erb", type: :view do
  it "displays the sample person's last name" do
    @person = FactoryBot.build(:person)
    @person.save!
    @person
    render
    expect(rendered).to match /#{@person.last_name}/
  end
end
