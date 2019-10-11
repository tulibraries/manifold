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
  attribute :date_of_incident
  attribute :preferred_date
  attribute :preferred_time
  attribute :type_of_incident
  attribute :other_incident
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
  attribute :course_number
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
  attribute :minors
  attribute :group
  attribute :easel
  attribute :file, attachment: true
  attribute :requestor
  attribute :location_of_filming
  attribute :date_of_filming
  attribute :time_of_filming
  attribute :duration_of_filming
  attribute :description
  attribute :temple_course_project
  attribute :additional_crew_name
  attribute :additional_email
  attribute :bachelor_degree
  attribute :institution_of_degree
  attribute :overall_gpa
  attribute :degrees_earned
  attribute :degree_program
  attribute :faculty_advisor
  attribute :degree_year
  attribute :personal_statement
  attribute :organizing_name
  attribute :organizing_phone
  attribute :organizing_email
  attribute :financial_name
  attribute :financial_phone
  attribute :financial_email
  attribute :foapal
  attribute :event_space
  attribute :event_title
  attribute :attendees
  attribute :date_of_event
  attribute :event_start
  attribute :event_end
  attribute :setup_style
  attribute :av_support
  attribute :partner_name
  attribute :partner_email


  def get_subject
    @forms = {
      "missing-book" => ["Missing Book Search Request", ["delcottos@temple.edu"]],
      "recall-book" => ["Request Recall of Books Already Checked Out", ["jhill@temple.edu"]],
      "purchase-request" => ["Purchase Request",  ["jbrian@temple.edu", "tub82123@temple.edu "]],
      "ask-scrc" => ["Special Collections Research Center: Ask a Question", "scrc@temple.edu"],
      "ir" => ["Incident Report", ["richieh@temple.edu", "bells@temple.edu"]],
      "data-purchase-grants-application" => ["Data Purchase Application", ["librarydatagrants@temple.edu"]],
      "library-instruction" => ["Request a Library Instruction Session", ["cshanley@temple.edu"]],
      "scrc-instruction" => ["SCRC Instruction Session/Visit Request", ["msly@temple.edu", "tuf12871@temple.edu"]],
      "proxy-account" => ["Proxy Account", ["jhill@temple.edu", "klehman@temple.edu"]],
      "table-request" => ["Library Staff and Registered Student Organization Table Request", ["john.pyle@temple.edu"]],
      "filming-request" => ["Guidelines for Requesting Permission to Use the Libraries for Filming", ["bells@temple.edu", "adiamond@temple.edu", "richieh@temple.edu"]],
      "cac-internal" => ["Cultural Analytics Certificate Internal Application", ["cacert@temple.edu"]],
      "cac-external" => ["Cultural Analytics Certificate External Application", ["cacert@temple.edu"]],
      "event-space-request" => ["Charles Library Event Space Request", ["charlesrooms@temple.edu"]],
      "graduate-locker-request" => ["Charles Library Graduate Studio Locker Request", ["mmoll@temple.edu"]],
      "partners-borrowing" => ["Partners Borrowing Privileges Application/Renewal", ["notices@temple.edu"]],
      "storage-request" => ["Storage Request", ["jhill@temple.edu", "musial@temple.edu"]]
    }

    @forms.fetch(form_type)
  end

  # Some forms don't supply a email and name, so they we're failing
  def default_from_name
    "Temple University Libraries"
  end

  def default_from_email
    "templelibraries@gmail.com"
  end

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      subject: get_subject[0],
      to: get_subject[1],
      from: %("#{name || default_from_name }" <#{email || default_from_email }>)
    }
  end
end
