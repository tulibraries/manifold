# frozen_string_literal: true

class BlogSerializer < ApplicationSerializer
  attributes :title, :base_url, :feed_path, :last_sync_date, :public_status
end
