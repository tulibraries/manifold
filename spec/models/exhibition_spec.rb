# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exhibition, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  describe "version all fields" do
    fields = {
      title: ["The Text 1", "The Text 2"],
      description: [ActionText::Content.new("Hello World"), ActionText::Content.new("Goodbye, Cruel World")],
      start_date: [Date.parse("2018/9/24"), DateTime.parse("2018/9/1")],
      end_date: [Date.parse("2018/10/24"), DateTime.parse("2018/10/10")],
    }

    fields.each do |k, v|
      example "#{k} changes" do
        skip("description not versionable") if k == :description
        exhibition = FactoryBot.create(:exhibition, k => v.first)
        exhibition.update(k => v.last)
        exhibition.save!
        expect(exhibition.versions.last.changeset[k]).to match_array(v)
      end
    end
  end

  it_behaves_like "categorizable"
  it_behaves_like "imageables"

end
