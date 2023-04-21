# frozen_string_literal: true

require "rails_helper"

RSpec.describe FuzzyFind::FinderService do
  class UndefinedModel; end
  class MockModel < ApplicationRecord
    #Stub this since we don't actually have a table for this
    def self.where(args)
      []
    end
  end

  let(:needle) { "thing_to_search_for" }
  let(:haystack_model) { MockModel }
  let(:attribute) { :name }
  let(:called_service) {
    described_class.call(
      needle:,
      haystack_model:,
      attribute:
    )
  }

  it "responds to #call" do
    expect(described_class).to respond_to :call
  end

  describe "#call" do
    it "throws an error if needle param is not supplied" do
      expect { described_class.call(haystack_model: MockModel) }.to raise_error(ArgumentError)
    end

    it "throws an error if haystack_model param is not supplied" do
      expect { described_class.call(needle: "thing_to_find") }.to raise_error(ArgumentError)
    end

    it "can be called without attribute argument" do
      expect {
          described_class.call(needle:, haystack_model:)
        }.to_not raise_error
    end

    it "can accept an attribute argument" do
      expect { called_service }.not_to raise_error
    end

    context "haystack_model is not a defined model" do
      let(:haystack_model) { UndefinedModel }
      it "raises a FuzzyFind::FindererService Error" do
        expect { called_service }.to raise_error(described_class::Error)
      end
    end

    context "search for a person" do
      before do
        Person.destroy_all
        building = FactoryBot.create(:building)
        @space = FactoryBot.create(:space, building:)
        FactoryBot.create(:person, buildings: [building])
        @group = FactoryBot.create(:group, space: @space, chair_dept_heads: [Person.take(1).first])

        @new_person = Person.create!(
          first_name: "New", last_name: "Person",
          phone_number: "1234567890",
          email_address: "new.person@temple.edu",
          groups: [@group], buildings: [building],
          job_title: "FooBarbarian")
      end

      after(:all) do
        Person.destroy_all
        Building.destroy_all
        Space.destroy_all
      end

      context "with a similar name" do
        it "returns the expected person" do
          expect(described_class.call(
                   needle: "Newish Person",
                   haystack_model: Person,
                   attribute: :name)
          ).to eql @new_person
        end

        context "and an simple additional attribute" do
          it "returns the expected person" do
            expect(
              described_class.call(
                needle: "Newish Person",
                haystack_model: Person,
                attribute: :name,
                addl_attribute: { email_address: "new.person@temple.edu" }
              )
            ).to eql @new_person
          end
        end

        context "and an association additional attribute" do
          context "passing an object" do
            it "returns the expected person" do
              expect(
                described_class.call(
                  needle: "Newish Person",
                  haystack_model: Person,
                  attribute: :name,
                  addl_attribute: { groups: @group }
                )
              ).to eql @new_person
            end
          end

          context "passing an id string" do
            it "returns the expected person" do
              expect(
                described_class.call(
                  needle: "Newish Person",
                  haystack_model: Person,
                  attribute: :name,
                  addl_attribute: { groups: @group.id.to_s }
                )
              ).to eql @new_person
            end
          end

          context "passing an id int" do
            it "returns the expected person" do
              expect(
                described_class.call(
                  needle: "Newish Person",
                  haystack_model: Person,
                  attribute: :name,
                  addl_attribute: { groups: @group.id.to_i }
                )
              ).to eql @new_person
            end
          end
        end
      end

      context "with a name that does not match at all" do
        it "returns nil" do
          expect(described_class.call(
                   needle: "kikkilij mqwwewe",
                   haystack_model: Person,
                   attribute: :name)
          ).to eql nil
        end
      end
    end

    context "search for a building" do
      before do
        FactoryBot.create(:building, name: "McGaw Library")
        @law = FactoryBot.create(:building, name: "Law Library")
      end

      after do
        Building.destroy_all
      end


      it "does not return Law Library when Paley is search term" do
        expect(described_class.call(
                 needle: "Paley Library",
                 haystack_model: Building,
                 attribute: :name,
                 addl_attribute: { address1: "1210 W. Berks Street" }
                 )
        ).not_to eql @law
      end

    end
  end
end
