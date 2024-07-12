# frozen_string_literal: true

class Space < ApplicationRecord
  has_paper_trail

  include Accountable
  include Categorizable
  include Draftable
  include HasPolicies
  include Imageable
  include InputCleaner
  include SetDates
  include Validators
  include SchemaDotOrgable
  extend FriendlyId

  friendly_id :name, use: [:slugged, :finders]
  friendly_id :slug_candidates, use: :slugged

  has_rich_text :description
  has_rich_text :draft_description
  has_rich_text :covid_alert
  has_rich_text :accessibility

  belongs_to :external_link, optional: true
  belongs_to :building
  validates :building_id, presence: true
  validates :name, presence: true

  auto_strip_attributes :email

  has_ancestry

  has_many :groups, dependent: :restrict_with_exception
  has_many :collections, dependent: :restrict_with_exception
  has_many :events, dependent: :restrict_with_exception
  has_many :exhibitions, dependent: :restrict_with_exception

  def slug_candidates
    [
      :name,
      [:name, :building]
    ]
  end

  def schema_dot_org_type
    "Place"
  end

  def additional_schema_dot_org_attributes
    {
      telephone: phone_number,
      containedInPlace: {
        "@type" => "containedInPlace",
        name: building.name,
        address: {
          "@type" => "PostalAddress",
          streetAddress: building.address1,
          addressLocality: building.address2
        }
      }
    }
  end

  def self.arrange_as_array(options = {}, hash = nil)
    hash ||= arrange(options)

    arr = []
    hash.each do |node, children|
      arr << node
      arr += arrange_as_array(options, children) unless children.empty?
    end
    arr
  end

  def label
    name
  end

  def cannot_destroy_message(exception)
    notice = exception.message
    model_name = self.class.name.downcase.pluralize
    model_id = self.id

    buildings = Building.all.any? { |b| b.spaces.any? { |s| s.id == model_id } } ?
      Building.all.map { |b| b if b.spaces.any? { |s| s.id == model_id } }.compact :
      nil

    collections = Collection.all.any? { |g| g.space_id == model_id } ?
      Collection.all.map { |c| c if c.space_id == model_id }.compact :
      nil

    groups = Group.all.any? { |g| g.space_id == model_id } ?
      Group.all.map { |g| g if g.space_id == model_id }.compact :
      nil

    events = Event.all.any? { |ev| ev.space_id == model_id } ?
      Event.all.map { |ev| ev if ev.space_id == model_id }.compact.take(3) :
      nil

    exhibits = Exhibition.all.any? { |ex| ex.space_id == model_id } ?
      Exhibition.all.map { |ex| ex if ex.space_id == model_id }.compact.take(3) :
      nil

    if notice.include? "Cannot delete record because of dependent"
      models = [buildings, collections, groups, events, exhibits].compact
      links = []
      models.each do |model|
        model_name = model.first.class.name.downcase.pluralize
        model.each do |model_instance|
          links << "<a href=/admin/#{model_name}/#{model_instance.slug}>#{model_instance.label}</a>"
        end
      end

      notice = "<p><strong>#{label}</strong> could not be deleted.<br />"
      notice +=  "It is still attached to the following Object(s).</p>"
      links.each do |link|
        notice += "<p><strong>#{link}</strong></p>"
      end
      notice += "<br /><p>Please remove and/or replace it there and try again.</p>"
      notice += "<br />"
    end

    notice
  end

  def weekly_hours
    if self.hours.present?
      all_hours = Google::SheetsConnector.call(feature: "hours", scope: self.hours)
      if all_hours.present?
        @weekly_hours = Google::WeeklyHours.new(hours: all_hours)
      else
        @weekly_hours = ""
      end
    end
  end
end
