# frozen_string_literal: true

json.array! @library_hours, partial: "library_hours/library_hour", as: :library_hour
