# frozen_string_literal: true

namespace :sync do
  desc "sync blogs by ID (`rake sync:blogs[ID Number]`) or sync all (`rake sync:blogs`)"
  task :blogs, [:id] => :environment do |t, args|
    args.with_defaults(id: nil)
    SyncService::Blogs.call(blog: args[:id])
  end
end
