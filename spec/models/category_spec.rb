# frozen_string_literal: true

require "rails_helper"


RSpec.describe Category, type: :model do

  let(:category) { FactoryBot.create(:category) }
  let(:parent_category) { FactoryBot.create(:category_parent) }


  describe "A basic category" do
    context "has a name" do
      it "doesn't error when built" do
        expect { category }.not_to raise_error
      end

      it "has a name attribute" do
        expect(category).to respond_to(:name)
      end

      it "returns the expectd value for name" do
        expect(category.name).to eql("Dreaming")
      end
    end

    context "when it doesn't have a name" do
      let(:category) { FactoryBot.build(:category) }
      it "should raise a validation error" do
        category.name = nil
        expect { category.save! }.to raise_error(/Name can't be blank/)
      end
    end
  end

  describe "A category with an image" do
    let(:category) { FactoryBot.create(:category, :with_image) }

    it "responds to image" do
      expect(category).to respond_to(:image)
    end

    it "responds with blob" do
      expect(category.image).to be_a_kind_of(ActiveStorage::Attached::One)
    end
  end

  describe "A category with an description" do
    let(:category) { FactoryBot.create(:category, :with_description) }

    it "responds to description" do
      expect(category).to respond_to(:description)
    end

    it "matches description" do
      expect(category.description).to match("It's what the category is about")
    end

    context "when it doesn't have a description" do
      it "should raise a validation error" do
        category.description = nil
        expect { category.save! }.to_not raise_error
      end
    end
  end

  describe "A category with a Get Help box" do
    let(:category) { FactoryBot.create(:category, :with_get_help) }

    it "responds to help text" do
      expect(category).to respond_to(:get_help)
    end

    it "matches help text" do
      expect(category.get_help).to match("It's what help is for")
    end
  end

  describe "#url" do

    let(:category) { FactoryBot.create(:category) }

    it "responds to .url" do
      expect(category).to respond_to(:url)
    end

    context "with custom_url defined" do
      let(:category) { FactoryBot.create(:category, :custom_url) }

      it "returns the expected path" do
        expect(category.url).to eq "http://sand.man"
      end
    end

    context "without a custom_url defined" do
      let(:policy) { FactoryBot.create(:policy) }
      let(:page) { FactoryBot.create(:page) }

      context "when items are in the ctaegory" do
        before do
          page.categories << category
          policy.categories << category
        end

        it "returns the url to the first item in #items" do
          expect(category.url).to eq url_for(category.items.first)
        end

        context "when an external link is in the category" do
          let(:external_link) { FactoryBot.create(:external_link) }
          before do
            external_link.categories << category
          end

          it "does not return the external_link as the url" do
            expect(category.url).to_not eq url_for(external_link)
          end
        end
      end

      context "when no items are in the category" do
        it "routes to the root url" do
          expect(category.url).to match(/^http:\/\/test.host\//)
        end
      end
    end



  end

  describe "#path" do
  let(:category) { FactoryBot.create(:category) }

  it "responds to .url" do
    expect(category).to respond_to(:path)
  end

  it "calls url with the only_path parameter" do
    expect(category).to receive(:url).with(only_path: true)
    category.path
  end
end
  describe "#items" do
    let(:building) { FactoryBot.create(:building) }
    let(:building2) { FactoryBot.create(:building) }
    let(:event) { FactoryBot.create(:event) }

    context "no items categorized" do
      it "should return an array" do
        expect(category.items).to be_a_kind_of(Array)
      end

      it "should be an empty array" do
        expect(category.items).to eql []
      end
    end

    context "items of one type in this category" do
      before do
        building.categories << category
        building2.categories << category
      end
      it "should return an array" do
        expect(category.items).to be_a_kind_of(Array)
      end

      it "should include expected items" do
        expect(category.items).to include(building, building2)
      end
    end

    context "items of multiple types in this category" do
      before do
        building.categories << category
        event.categories << category
      end

      it "should include expected items" do
        expect(category.items).to include(building, event)
      end

      context "when limit_to parameter is passed with a Class name" do
        it "returns items of that type" do
          expect(category.items(limit_to: [:event])).to include(event)
        end

        it "does not return items of other types" do
          expect(category.items(limit_to: [:event])).to_not include(building)
        end
      end

      context "when exclude paramater is passed with a Class name" do
        it "does not include items of that type" do
          expect(category.items(exclude: [:event])).to_not include(event)
        end

        it "does include items of other types" do
          expect(category.items(exclude: [:event])).to include(building)
        end
      end
    end

    context "deleting an categorized item" do
      before do
        building.categories << category
      end

      it "is no longer in the category items list" do
        old_building = building
        building.destroy
        expect(category.items).not_to include(old_building)
      end
    end
    context "child_categories" do

       context "when the category has child categories" do
         it "returns an array of those categories, but not other" do
           building.categories << parent_category
           category.categories << parent_category
           expect(parent_category.child_categories).to include(category)
           expect(parent_category.child_categories).not_to include(building)
         end
       end
       context "when it has no child categories" do
         it "returns an empty array" do
           building.categories << parent_category
           expect(parent_category.child_categories).to eql([])
         end
       end
     end
  end

  context "#categories" do

    it "is responded to" do
      expect(category).to respond_to(:categories)
    end

    it "allows a category to be added" do
      expect { parent_category.categories << category }.not_to raise_error
    end

    it "returns a collection of categories" do
      parent_category.categories << category
      expect(parent_category.categories).to include(category)
    end
  end

  #convenience method for soecs that return paths to other models
  def url_for(instance)
    Rails.application.routes.url_helpers.url_for(instance)
  end
end
