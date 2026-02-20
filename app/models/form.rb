# frozen_string_literal: true

class Form < MailForm::Base
  attribute :name
  attribute :email
  attribute :address
  attribute :outside_vendor_fees, :boolean
  attribute :duplication_limits, :boolean
  attribute :copyright_acknowledgment, :boolean
  attribute :comments
  attribute :form_type
  attribute :recipients
  attribute :request_title
  attribute :collection_title
  attribute :identifier
  attribute :notes
  attribute :format
  attribute :request_title_01
  attribute :collection_title_01
  attribute :identifier_01
  attribute :notes_01
  attribute :format_01
  attribute :request_title_02
  attribute :collection_title_02
  attribute :identifier_02
  attribute :notes_02
  attribute :format_02
  attribute :request_title_03
  attribute :collection_title_03
  attribute :identifier_03
  attribute :notes_03
  attribute :format_03
  attribute :request_title_04
  attribute :collection_title_04
  attribute :identifier_04
  attribute :notes_04
  attribute :format_04
  attribute :request_title_05
  attribute :collection_title_05
  attribute :identifier_05
  attribute :notes_05
  attribute :format_05
  attribute :request_title_06
  attribute :collection_title_06
  attribute :identifier_06
  attribute :notes_06
  attribute :format_06
  attribute :request_title_07
  attribute :collection_title_07
  attribute :identifier_07
  attribute :notes_07
  attribute :format_07
  attribute :request_title_08
  attribute :collection_title_08
  attribute :identifier_08
  attribute :notes_08
  attribute :format_08
  attribute :request_title_09
  attribute :collection_title_09
  attribute :identifier_09
  attribute :notes_09
  attribute :format_09
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
  attribute :book_title
  attribute :missing_title
  attribute :recall_title
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
  attribute :course_code
  attribute :course_number
  attribute :reserve_duration
  attribute :number_of_copies
  attribute :faculty_admin_name
  attribute :faculty_admin_email
  attribute :faculty_admin_tuid
  attribute :proxy_name
  attribute :proxy_tuid
  attribute :proxy_email
  attribute :proxy_account_email
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
  attribute :additional_setup_requirements
  attribute :attendees
  attribute :date_of_event
  attribute :event_start
  attribute :event_end
  attribute :setup_style
  attribute :av_support
  attribute :catering
  attribute :partner_name
  attribute :partner_email
  attribute :faculty_advisor_email
  attribute :policy_check
  attribute :referrer
  attribute :school_visit
  attribute :protocol_title
  attribute :review_update
  attribute :rationale
  attribute :explicit_statement
  attribute :information_sources
  attribute :included_keywords
  attribute :excluded_keywords
  attribute :data_plan
  attribute :independent_reviewers
  attribute :outcomes
  attribute :quantitative_analysis
  attribute :quantitative_analysis_other
  attribute :bio_statistician
  attribute :bio_statistician_other
  attribute :summary_description
  attribute :evidence_assessment
  attribute :citations
  attribute :librarian_contact
  attribute :librarian_contact_other
  attribute :authorship_permission
  attribute :authorship_permission_other
  attribute :other_reviews
  attribute :other_reviews_other
  attribute :publication_journal
  attribute :first_choice_date
  attribute :second_choice_date
  attribute :instruction_mode
  attribute :total_number_of_production_members
  attribute :mobile_number
  attribute :mobile_telephone_number_of_the_key_crew_member
  attribute :exhibit_title
  attribute :exhibit_date_range
  attribute :exhibit_location
  attribute :exhibit_display_methods
  attribute :exhibit_funding_source
  attribute :exhibit_insurance
  attribute :exhibit_temple_connection
  attribute :exhibit_temple_connection_description
  attribute :exhibit_policies_acknowledgement
  attribute :format_preference
  attribute :format_preference_other
  attribute :reason_for_request
  attribute :asrs_only
  attribute :id_acknowledgment
  # Copy-requests specific fields
  attribute :box
  attribute :folder
  attribute :estimated_pages, :integer
  attribute :pricing_tiff, :boolean
  attribute :pricing_pdf, :boolean
  attribute :pricing_photocopy, :boolean

  # Copy-requests repeatable fields (up to 10 requests)
  (1..9).each do |i|
    index = i.to_s.rjust(2, "0")
    attribute :"box_#{index}"
    attribute :"folder_#{index}"
    attribute :"estimated_pages_#{index}", :integer
    attribute :"pricing_tiff_#{index}", :boolean
    attribute :"pricing_pdf_#{index}", :boolean
    attribute :"pricing_photocopy_#{index}", :boolean
  end

  # AV-requests specific fields
  attribute :request_title
  attribute :collection_title
  attribute :identifier
  attribute :notes
  attribute :format

  # av-requests repeatable fields (up to 10 requests)
  (1..9).each do |i|
    index = i.to_s.rjust(2, "0")
    attribute :"request_title_#{index}"
    attribute :"collection_title_#{index}"
    attribute :"identifier_#{index}"
    attribute :"notes_#{index}"
    attribute :"format_#{index}"
  end

  # Some forms don't supply an email and name, so they were failing
  # Keep From aligned with authenticated Gmail account.
  def default_from_name
    "Temple University Libraries"
  end

  def default_from_email
    "templelibraries@gmail.com"
  end

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts. This overrides the headers from the mail_form gem.
  def headers
    parsed_recipients = parse_recipients

    headers = {
      subject: title,
      to: parsed_recipients,
      from: %("#{ default_from_name }" <#{ default_from_email }>)
    }
    if email.present?
      headers[:reply_to] = name.present? ? %("#{name}" <#{email}>) : email
      headers[:cc] = email
    end
    headers
  end

  private

    def parse_recipients
      return [default_from_email] if recipients.blank?

      parsed = JSON.parse(recipients)
      Array(parsed).compact.presence || [default_from_email]
    rescue JSON::ParserError => e
      Rails.logger.warn "Failed to parse form recipients JSON: #{e.message}"
      [default_from_email]
    end
end
