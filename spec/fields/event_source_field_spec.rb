# frozen_string_literal: true

require "rails_helper"

RSpec.describe EventSourceField do
  def label_for(guid)
    described_class.new(:source, nil, :index, resource: Event.new(guid:)).to_s
  end

  it "labels legacy Temple guids" do
    expect(label_for("389131")).to eq("Temple")
  end

  it "labels LibCal guids" do
    expect(label_for("16528907")).to eq("LibCal")
  end

  it "is blank when there is no guid" do
    expect(label_for(nil)).to eq("")
  end
end
