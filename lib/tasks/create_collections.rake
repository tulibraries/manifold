# frozen_string_literal: true

namespace :db do # ~> NoMethodError: undefined method `namespace' for main:Object
  namespace :populate do
    unless Rails.env.production?
      require "populate"
    end

    task collections: :environment do

      9.times do
        name = SecureRandom.base58(24)
        collection = Collection.new(name: name,
                                    description: "test collection",
                                    subject: ["test"], 
                                    contents: "test", 
                                    building_id: 2,
                                    space_id: 2
                                    )
        collection.save
      end
      
    end

  end
end
