# frozen_string_literal: true

# Finds ActiveStorage::VariantRecord rows for event images whose derivative is
# missing from the storage service and destroys them so the derivative can be
# regenerated.
#
# Dry run by default:
#
#   rake active_storage:repair_event_variant_records
#   rake active_storage:repair_event_variant_records COMMIT=1
namespace :active_storage do
  desc "destroy event variant records whose derivative is missing from storage (dry run unless COMMIT=1)"
  task repair_event_variant_records: :environment do
    commit = ENV["COMMIT"].present?

    blob_ids = ActiveStorage::Attachment.where(record_type: "Event").select(:blob_id)
    scope = ActiveStorage::VariantRecord.where(blob_id: blob_ids).includes(image_attachment: :blob)

    checked = 0
    orphans = []

    scope.find_each do |variant_record|
      checked += 1
      blob = variant_record.image_attachment&.blob

      next if blob.present? && blob.service.exist?(blob.key)

      orphans << variant_record
      puts "orphan: variant_record #{variant_record.id} (blob #{variant_record.blob_id}, key #{blob&.key.inspect})"
    end

    puts "\nChecked #{checked} event variant record(s); found #{orphans.size} orphan(s)."

    if commit
      orphans.each(&:destroy)
      puts "Destroyed #{orphans.size} orphaned variant record(s). They will regenerate on next request or sync."
    else
      puts "Dry run — nothing destroyed. Re-run with COMMIT=1 to apply."
    end
  end
end
