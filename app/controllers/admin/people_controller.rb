# frozen_string_literal: true

module Admin
  class PeopleController < Admin::ApplicationController
    include Admin::Detachable
  end
end
