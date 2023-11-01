# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::PeopleController, type: :controller do
  let(:account) { FactoryBot.create(:account, admin: true) }
  let!(:group) { FactoryBot.create(:group) }
  let(:person) { group.chair_dept_heads.first }

  describe "DELETE #destroy" do
    render_views true
    it "does not allow person to be deleted if chair of group" do
      sign_in(account)
      expect { delete :destroy, params: { id: person.id } }.to_not change(Person, :count)
      expect(flash[:notice]).to match(person.label)
    end
  end
end
