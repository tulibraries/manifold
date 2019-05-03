class GroupSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :group_type, :external, :add_to_footer, :label
end
