# frozen_string_literal: true

class FormSerializer < ApplicationSerializer
  link :self, Proc.new { |form| form.link }
end
