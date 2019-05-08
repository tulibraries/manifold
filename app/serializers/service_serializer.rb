class ServiceSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :access_description, :access_link, :service_policies,
    :intended_audience, :service_category, :hours, :add_to_footer, :label
end
