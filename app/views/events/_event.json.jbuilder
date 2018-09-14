json.extract! event, :id, :title, :blurb, :link, :date, :time, :type, :tags, :created_at, :updated_at
json.url event_url(event, format: :json)
