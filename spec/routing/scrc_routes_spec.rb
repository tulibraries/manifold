# frozen_string_literal: true

require "rails_helper"

RSpec.describe "SCRC routes", type: :routing do
  it "routes /scrc/planyourvisit to webpages#scrc_planyourvisit" do
    expect(get: "/scrc/planyourvisit").to route_to(
      controller: "webpages",
      action: "scrc_planyourvisit"
    )
  end

  it "generates the correct path" do
    expect(scrc_planyourvisit_path).to eq("/scrc/planyourvisit")
  end
end
