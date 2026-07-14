# frozen_string_literal: true

require "administrate/field/base"

# Labels an event by the system that created it, so the LibCal changeover
# duplicates can be told apart in the admin. The two systems mint guids in
# disjoint ranges -- the legacy Temple feed used 6-digit ids, LibCal uses 8-digit
# ones -- and only the Temple row of a duplicate pair is safe to delete: deleting
# the LibCal row just recreates it on the next sync.
class EventSourceField < Administrate::Field::Base
  LIBCAL_GUID_DIGITS = 7

  def self.sortable?
    false
  end

  def data
    resource.guid
  end

  def to_s
    return "" if data.blank?

    libcal? ? "LibCal" : "Temple"
  end

  def libcal?
    data.to_s.length >= LIBCAL_GUID_DIGITS
  end
end
