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
  attribute :type_of_incident
  attribute :other_incident
  attribute :time_of_incident
  attribute :date_of_incident
  attribute :location_where_incident_occured
  attribute :primary_relevant_person
  attribute :primary_email
  attribute :primary_affiliation
  attribute :secondary_relevant_person
  attribute :secondary_email
  attribute :secondary_affiliation
  attribute :incident_description
  attribute :victim_complaint_statement
  attribute :action_taken
  attribute :police_report_number
  attribute :other_action_taken
  attribute :supervisor_notified


  def get_subject
    @forms = {
      "missing-book" => ["Missing Book Search Request", "steven.ng@temple.edu"],
      "recall-book" => ["Request Recall of Books Already Checked Out",  "cdoyle@temple.edu"],
      "purchase-request" => ["Purchase Request",  "cdoyle@temple.edu"],
      "ask-scrc" => ["Special Collections Research Center: Ask a Question", "cdoyle@temple.edu"],
      "ir" => ["Incident Report", "cdoyle@temple.edu"] }

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
