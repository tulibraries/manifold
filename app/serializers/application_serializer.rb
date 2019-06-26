# frozen_string_literal: true

class ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :label, :updated_at
end
