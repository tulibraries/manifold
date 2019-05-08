class PolicySerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :effective_date, :expiration_date, :category, :label
end
