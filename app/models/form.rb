# frozen_string_literal: true

class Form < MailForm::Base
  attribute :name
  attribute :email
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
  attribute :call_number
  attribute :isbn
  attribute :edition
  attribute :publisher
  attribute :source_of_information
  attribute :reason_for_purchase
  attribute :pickup_location
  attribute :cancellation_date
  attribute :type_of_incident
  attribute :other_incident
  attribute :date_of_incident
  attribute :location_where_incident_occurred
  attribute :primary_relevant_person
  attribute :primary_email
  attribute :primary_affiliation
  attribute :secondary_relevant_person
  attribute :secondary_email
  attribute :secondary_affiliation
  attribute :incident_description
  attribute :victim_complainant_statement
  attribute :action_taken
  attribute :police_report_number
  attribute :other_action_taken
  attribute :supervisor_notified
  attribute :research_group
  attribute :project_purpose
  attribute :dataset
  attribute :interest_level
  attribute :years_limit
  attribute :data_creator
  attribute :data_discovery
  attribute :course_title
  attribute :reserve_duration
  attribute :number_of_copies
  attribute :faculty_admin_name
  attribute :faculty_admin_email
  attribute :faculty_admin_tuid
  attribute :proxy_name
  attribute :proxy_tuid
  attribute :proxy_account_expiration
  attribute :class_time
  attribute :class_days
  attribute :number_of_students
  attribute :requested_date
  attribute :course_level
  attribute :campus
  attribute :other





  def get_subject
    @forms = {
      "missing-book" => ["Missing Book Search Request", "cdoyle@temple.edu"],
      "recall-book" => ["Request Recall of Books Already Checked Out",  "cdoyle@temple.edu"],
      "purchase-request" => ["Purchase Request",  "cdoyle@temple.edu"],
      "ask-scrc" => ["Special Collections Research Center: Ask a Question", "scrc@temple.edu"],
      "ir" => ["Incident Report", ["cdoyle@temple.edu", "richieh@temple.edu", "bells@temple.edu"]],
      "data-purchase-grants-application" => ["Data Purchase Application", "cdoyle@temple.edu"],
      "library-instruction" => ["Request a Library Instruction Session", "cdoyle@temple.edu"],
      "proxy-account" => ["Proxy Account", ["cdoyle@temple.edu", "jhill@temple.edu", "klehman@temple.edu"]] }

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
