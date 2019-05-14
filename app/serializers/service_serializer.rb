# frozen_string_literal: true

class ServiceSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :access_description, :access_link, :service_policies,
    :intended_audience, :service_category, :hours, :add_to_footer
end
