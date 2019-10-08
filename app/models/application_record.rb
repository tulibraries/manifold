# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def todays_date
    @today = Date.today.strftime("%Y-%m-%d 00:00:00")
    @today.to_date.strftime("%^A, %^B %d, %Y ")
  end

  def category_weight
    @weight
  end

  def category_weight=(weight)
    @weight = weight
  end

  def label
    respond_to?(label_method) ? self[label_method] : "#{self.class.to_s}_#{id}"
  end

  def label_method
    :name
  end
end
