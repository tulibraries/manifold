# frozen_string_literal: true

class MenuGroupCategory < ApplicationRecord
  belongs_to :category
  belongs_to :menu_group
end
