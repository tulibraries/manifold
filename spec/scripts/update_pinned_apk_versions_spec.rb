# frozen_string_literal: true

require_relative "../../.github/scripts/update_pinned_apk_versions"

RSpec.describe "update_pinned_apk_versions" do
  describe "pinned_packages" do
    it "includes the final package in each apk add command" do
      contents = <<~DOCKERFILE
        RUN apk add -U --no-cache \\
              postgresql17-client=17.12-r0 \\
              tzdata=2026f-r0 && \\
            apk add -U --no-cache --virtual build-dependencies \\
              postgresql17-dev=17.11-r0 && \\
            bundle install
      DOCKERFILE

      expect(pinned_packages(contents)).to include(
        "postgresql17-client" => "17.12-r0",
        "tzdata" => "2026f-r0",
        "postgresql17-dev" => "17.11-r0"
      )
    end
  end

  describe "apply_updates" do
    it "updates a -dev package when its version changes" do
      contents = "postgresql17-dev=17.11-r0 && \\\n"

      updated_contents, updates = apply_updates(
        contents,
        { "postgresql17-dev" => "17.11-r0" },
        { "postgresql17-dev" => "17.12-r0" }
      )

      expect(updated_contents).to eq("postgresql17-dev=17.12-r0 && \\\n")
      expect(updates).to eq("postgresql17-dev" => ["17.11-r0", "17.12-r0"])
    end
  end
end
