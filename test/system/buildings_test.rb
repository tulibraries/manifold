require "application_system_test_case"

class BuildingsTest < ApplicationSystemTestCase
  setup do
    @building = buildings(:one)
  end

  test "visiting the index" do
    visit buildings_url
    assert_selector "h1", text: "Buildings"
  end

  test "creating a Building" do
    visit buildings_url
    click_on "New Building"

    fill_in "Accessibility", with: @building.accessibility
    fill_in "Address1", with: @building.address1
    fill_in "Campus", with: @building.campus
    fill_in "Description", with: @building.description
    fill_in "Directions Map", with: @building.directions_map
    fill_in "Email", with: @building.email
    fill_in "Hours", with: @building.hours
    fill_in "Image", with: @building.image
    fill_in "Name", with: @building.name
    fill_in "Phone Number", with: @building.phone_number
    fill_in "Temple Building Code", with: @building.temple_building_code
    click_on "Create Building"

    assert_text "Building was successfully created"
    click_on "Back"
  end

  test "updating a Building" do
    visit buildings_url
    click_on "Edit", match: :first

    fill_in "Accessibility", with: @building.accessibility
    fill_in "Address1", with: @building.address1
    fill_in "Campus", with: @building.campus
    fill_in "Description", with: @building.description
    fill_in "Directions Map", with: @building.directions_map
    fill_in "Email", with: @building.email
    fill_in "Hours", with: @building.hours
    fill_in "Image", with: @building.image
    fill_in "Name", with: @building.name
    fill_in "Phone Number", with: @building.phone_number
    fill_in "Temple Building Code", with: @building.temple_building_code
    click_on "Update Building"

    assert_text "Building was successfully updated"
    click_on "Back"
  end

  test "destroying a Building" do
    visit buildings_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Building was successfully destroyed"
  end
end
