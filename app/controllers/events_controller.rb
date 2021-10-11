# frozen_string_literal: true

class EventsController < ApplicationController
  include SetInstance
  include RedirectLogic
  before_action :set_event, only: [:show]
  before_action :init, only: [:index, :past]
  include EventFilters


  def index
    events = @all_events.having("start_time >= ?", @today).order(start_time: :asc)
    @events = return_events(events)
    @exhibitions = Exhibition.where("end_date >= ?", @today)
                             .where(promoted_to_events: true)
                             .order(start_date: :desc, end_date: :desc)
                             .take(4)
    @mailing_list = ExternalLink.find_by(slug: "events-mailing-list")
    @intro = Webpage.find_by(slug: "events-intro")
    respond_to do |format|
      format.html
      format.json { render json: EventSerializer.new(@all_events) }
    end
  end

  def past
    events = @all_events.having("start_time < ?", @today).order(start_time: :desc)
    @exhibitions = Exhibition.where("end_date < ?", @today)
                   .where(promoted_to_events: true)
                   .order(end_date: :desc, start_date: :desc)
                   .take(3)
    @events = return_events(events)
    @intro = Webpage.find_by(slug: "events-intro")
    respond_to do |format|
      format.html
      format.json { render json: EventSerializer.new(@all_events) }
    end
  end

  def return_events(events)
    @events = []
    if params["type"].present?
      @events = events.having("lower(tags) LIKE ?", "%#{params[:type].downcase}%").order(:start_time) unless action_name == "past"
      @events = events.having("lower(event_type) LIKE ?", "%#{params[:type].downcase}%").order(:start_time) if action_name == "past"
    end

    if params["date"].present?
      day_start = Date.parse(params[:date]).beginning_of_day
      day_end = Date.parse(params[:date]).end_of_day
      @events = events.having("start_time > ?", day_start)
                      .merge(events.having("start_time < ?", day_end))
                      .order(:start_time)
    end

    @event_types = all_types(events)
    @event_dates = dates_list(events)

    unless @events.empty?
      @event_dates = dates_list(@events)
    end
    #
    if @events.present?
      unless action_name == "past"
        events_list = Event.where(id: @events.map(&:id)).order(:start_time)
      else
        events_list = Event.where(id: @events.map(&:id)).order(start_time: :desc)
      end
      @events_list = events_list.page params[:page]
    else
      if params[:date].present?
        @events_list = @events.page params[:page]
      else
        unless params[:type].present? && @events.empty?
          @events_list = events.page params[:page]
        else
          @events_list = @events.page params[:page]
        end
      end
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: EventSerializer.new(@event) }
    end
  end

  private
    def init
      @all_events = Event.group(:id)
      @featured_events = Event.where(featured: true).order(:start_time).take(3)
      @today = Date.current
      @new_tags = t("manifold.events.tags").map { |tag| tag[1] }.sort
    end

    def set_event
      @event = find_instance
      @event_url = @event.event_url unless @event.nil?
      return redirect_or_404(@event)
    end
end
