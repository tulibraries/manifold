# frozen_string_literal: true

class FormsController < ApplicationController

  def new
    @form = Form.new
    render template: "forms/#{params[:type]}"
  end


  def create
    @form = Form.new(params[:form])
    @form.request = request
    if @form.deliver
      flash.now[:notice] = 'Thank you for your message. We will contact you soon!'
    else
      flash.now[:error] = 'Cannot send message.'
      render :new
    end
  end



  def incident_report
    name = params[:name]
    email = params[:email]
    tuid = params[:tuid]
    phone = params[:phone]
    affiliation = params[:affiliation]
    department = params[:department]
    pickup_location = params[:pickup_location]
    cancel_by = params[:cancel_by]
    title = params[:title]
    author = params[:author]
    callnum = params[:callnum]
    comments = params[:comments]
    subsitute_edition = params[:subsitute_edition]
    FormsMailer.recall(name, email, tuid, phone, affiliation, department, pickup_location, cancel_by, title, author, callnum, comments, subsitute_edition).deliver_now
  end
  def missing_book
    name = params[:name]
    email = params[:email]
    tuid = params[:tuid]
    phone = params[:phone]
    affiliation = params[:affiliation]
    department = params[:department]
    pickup_location = params[:pickup_location]
    cancel_by = params[:cancel_by]
    title = params[:title]
    author = params[:author]
    callnum = params[:callnum]
    comments = params[:comments]
    subsitute_edition = params[:subsitute_edition]
    FormsMailer.recall(name, email, tuid, phone, affiliation, department, pickup_location, cancel_by, title, author, callnum, comments, subsitute_edition).deliver_now
  end
  def contact
    name = params[:name]
    email = params[:email]
    tuid = params[:tuid]
    phone = params[:phone]
    affiliation = params[:affiliation]
    department = params[:department]
    pickup_location = params[:pickup_location]
    cancel_by = params[:cancel_by]
    title = params[:title]
    author = params[:author]
    callnum = params[:callnum]
    comments = params[:comments]
    subsitute_edition = params[:subsitute_edition]
    FormsMailer.recall(name, email, tuid, phone, affiliation, department, pickup_location, cancel_by, title, author, callnum, comments, subsitute_edition).deliver_now
  end
  def recall
    name = params[:name]
    email = params[:email]
    tuid = params[:tuid]
    phone = params[:phone]
    affiliation = params[:affiliation]
    department = params[:department]
    pickup_location = params[:pickup_location]
    cancel_by = params[:cancel_by]
    title = params[:title]
    author = params[:author]
    callnum = params[:callnum]
    comments = params[:comments]
    subsitute_edition = params[:subsitute_edition]
    FormsMailer.recall(name, email, tuid, phone, affiliation, department, pickup_location, cancel_by, title, author, callnum, comments, subsitute_edition).deliver_now
  end
  def ask_scrc
    name = params[:name]
    email = params[:email]
    tuid = params[:tuid]
    phone = params[:phone]
    affiliation = params[:affiliation]
    department = params[:department]
    pickup_location = params[:pickup_location]
    cancel_by = params[:cancel_by]
    title = params[:title]
    author = params[:author]
    callnum = params[:callnum]
    comments = params[:comments]
    subsitute_edition = params[:subsitute_edition]
    FormsMailer.recall(name, email, tuid, phone, affiliation, department, pickup_location, cancel_by, title, author, callnum, comments, subsitute_edition).deliver_now
  end
  def index
  end
end
