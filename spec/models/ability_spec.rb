# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ability, type: :model do
  describe "regular ability" do
    let(:account) { FactoryBot.create(:account) }
    let(:ability) { Ability.new(account) }
    example "ability" do
      expect(ability.can?(:read, Building)).to be(true)
      expect(ability.can?(:read, Space)).to be(true)
      expect(ability.can?(:read, Group)).to be(true)
      expect(ability.can?(:read, Person)).to be(true)
      expect(ability.can?(:read, Alert)).to be(true)
      expect(ability.can?(:read, Service)).to be(true)
      expect(ability.can?(:read, Collection)).to be(true)
    end
    example "inability" do
      expect(ability.can?(:update, Alert)).to be(false)
      expect(ability.can?(:manage, :all)).to be(false)
    end
  end

  describe "alert ability" do
    let(:account) { FactoryBot.create(:account, alertability: true) }
    let(:ability) { Ability.new(account) }
    example "ability" do
      expect(ability.can?(:update, Alert)).to be(true)
    end
    example "inability" do
      expect(ability.can?(:manage, :all)).to be(false)
    end
  end

  describe "admin ability" do
    let(:account) { FactoryBot.create(:account, admin: true) }
    let(:ability) { Ability.new(account) }
    example "ability" do
      expect(ability.can?(:manage, :all)).to be((true))
    end
  end
end
