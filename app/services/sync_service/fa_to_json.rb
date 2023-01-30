# frozen_string_literal: true

class SyncService::FaToJson
  def self.call

    File.open("public/finding_aids.json", "w") { |file| file.write(FindingAidSerializer.new(FindingAid.all).serializable_hash.to_json) }

  end
end
