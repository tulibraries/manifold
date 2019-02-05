# frozen_string_literal: true

class PoliciesController < ApplicationController
  load_and_authorize_resource
  before_action :set_policy, only: [:show]

  def show
    @policies = Policy.all
    groups = @policies.group_by { |policy| policy.category }
    @grouped_policies = Hash[ groups.sort_by { |key, val| key } ]
    @key_group = @policy.category
  end

  private
    def set_policy
      @policy = Policy.find(params[:id])
    end
end
