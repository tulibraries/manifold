# frozen_string_literal: true

class BlogSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :base_url, :feed_path, :last_sync_date, :public_status, :label
end
