# frozen_string_literal: true

class Form < MailForm::Base
  attribute :name,      validate: true
  attribute :email,     validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :comments
  attribute :form_type
  attribute :tu_id
  attribute :phone
  attribute :department
  attribute :affiliation
  attribute :affiliation_other
  attribute :material_type
  attribute :material_type_other
  attribute :substitute_edition
  attribute :author
  attribute :title
  attribute :year
  attribute :call_num
  attribute :publisher
  attribute :source
  attribute :reason
  attribute :pickup_location
  attribute :cancellation_date


  def get_subject
    @forms = {
      "missing-book" => ["Missing Book Search Request", "cdoyle@temple.edu"],
      "recall-book" => ["Request Recall of Books Already Checked Out",  "cdoyle@temple.edu"],
      "purchase-request" => ["Purchase Request",  "cdoyle@temple.edu"],
      "ask-scrc" => ["Special Collections Research Center: Ask a Question", "cdoyle@temple.edu"] }

    @forms.fetch(form_type)
  end

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      subject: get_subject[0],
      to: get_subject[1],
      from: %("#{name}" <#{email}>)
    }
  end
end
