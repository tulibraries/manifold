# frozen_string_literal: true

class AccountFormInfo < ApplicationRecord
  belongs_to :account
  belongs_to :form_info
end
