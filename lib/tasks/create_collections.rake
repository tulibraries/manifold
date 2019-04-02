# frozen_string_literal: true

namespace :db do # ~> NoMethodError: undefined method `namespace' for main:Object
  namespace :populate do
    unless Rails.env.production?
      require "populate"
    end

    task collections: :environment do

      collections = ["Contemporary Culture Collections",
                    "Manuscripts and Archives",
                    "Paskow Science Fiction Collection (Science Fiction and Fantasy)",
                    "Philadelphia Dance Collection",
                    "Philadelphia Jewish Archives Collection",
                    "Printing, Publishing, and Bookselling Collections",
                    "Rare Books",
                    "University Archives",
                    "Urban Archives",
                    "Charles L. Blockson Afro-American Collection"]

      12.times.with_index do |c, i|

        collection = Collection.new(name: collections[i],
                                    description: "test collection",
                                    subject: ["test"],
                                    contents: "test",
                                    building_id: 2,
                                    space_id: 2
                                    )
        collection.save
      end

      def get_names
      end

    end

  end
end
