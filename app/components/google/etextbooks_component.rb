# frozen_string_literal: true

class Google::EtextbooksComponent < ViewComponent::Base
  def initialize(etexts:, title:, description:, column:, direction:)
    @title = title
    @description = description
    @base_url = Rails.application.config.search_catalog
    @sort_orders = { "course" => "asc", "professor" => "asc" }
    column = column ? column : "course"
    direction = direction ? direction : @sort_orders["#{column}"]
    @etexts = sort!(etexts&.values, column, direction)
  end

  private

    def sort!(etexts, column, direction)
      if direction != @sort_orders["#{column}"]
        @sort_orders["#{column}"] = direction
      end
      if column == "course"
        return etexts.sort_by { |a, b, c, d, e| [b, c, d] } if @sort_orders["#{column}"] == "asc"
        return etexts.sort_by { |a, b, c, d, e| [b, c, d] }.reverse if @sort_orders["#{column}"] == "desc"
      else
        return etexts.sort_by { |a, b, c, d, e| [e] } if @sort_orders["#{column}"] == "asc"
        return etexts.sort_by { |a, b, c, d, e| [e] }.reverse if @sort_orders["#{column}"] == "desc"
      end
    end

    def sort_link(column:, label:, direction:)
      if direction != @sort_orders["#{column}"]
        @sort_orders["#{column}"] = direction
      end if direction.present?

      content_tag(:span, label, { id: column,
                                  data: {
                                    controller: "etexts-component",
                                    action: "click->etexts-component#sort_column",
                                    column:,
                                    direction: @sort_orders["#{column}"],
                                    target: "etexts"
                                  },
                                  style: "cursor:pointer;" })
    end
end
