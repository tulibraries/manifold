require "rails_helper"

RSpec.describe "Error system test", type: :system do
  it "raises an error" do
    expect do
      raise "System-level boom!"
    end.to raise_error("System-level boom!")
  end
end
