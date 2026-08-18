# frozen_string_literal: true

# Finds ActiveStorage::VariantRecord rows whose derivative is missing from the
# storage service and destroys them so the derivative can be regenerated.
#
# ActiveStorage::VariantWithRecord#processed? only checks that the record exists;
# it never asks the service. A record whose object is gone therefore blocks
# regeneration permanently and every request for that variant 404s. Destroying
# the record is what unblocks it.
#
# Dry run by default:
#
#   rake active_storage:repair_variant_records
#   rake active_storage:repair_variant_records COMMIT=1
#   rake active_storage:repair_variant_records MODEL=Event COMMIT=1
namespace :active_storage do
  desc "destroy variant records whose derivative is missing from storage (dry run unless COMMIT=1)"
  task repair_variant_records: :environment do
    commit = ENV["COMMIT"].present?
    model = ENV["MODEL"].presence

    scope = ActiveStorage::VariantRecord.includes(image_attachment: :blob)

    if model
      blob_ids = ActiveStorage::Attachment.where(record_type: model).select(:blob_id)
      scope = scope.where(blob_id: blob_ids)
    end

    checked = 0
    orphans = []

    scope.find_each do |variant_record|
      checked += 1
      blob = variant_record.image_attachment&.blob

      next if blob.present? && blob.service.exist?(blob.key)

      orphans << variant_record
      puts "orphan: variant_record #{variant_record.id} (blob #{variant_record.blob_id}, " \
           "key #{blob&.key.inspect}, created #{variant_record.created_at})"
    end

    puts "\nChecked #{checked} variant record(s)#{" for #{model}" if model}; found #{orphans.size} orphan(s)."

    if orphans.any?
      timestamps = orphans.map(&:created_at).compact
      puts "Orphan created_at range: #{timestamps.min} .. #{timestamps.max}" if timestamps.any?
    end

    if commit
      orphans.each(&:destroy)
      puts "Destroyed #{orphans.size} orphaned variant record(s). They will regenerate on next request or sync."
    else
      puts "Dry run — nothing destroyed. Re-run with COMMIT=1 to apply."
    end
  end
end
