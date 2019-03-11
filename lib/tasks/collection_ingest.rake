# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'json'

namespace :db do
  namespace :seed do

  # desc 'separate files'
  # task :run_updates, [:file_path] => :environment do |t, args|
  #   filepath = args.fetch(:file_path, nil)
  #   if filepath && File.exist?(filepath) 
  #     Rake::Task["db:seed:collections"].invoke(filepath)
  #   end
  # end

  desc "Pull in Finding Aids from Drupal Export"
  task :collections, [:filepath] => :environment do |t, args|

  doc = args.fetch(:filepath, nil)

  # doc = JSON.parse(open('http://oak.library.temple.edu/scrc/collections/pjac/export/json'))

  # if BOOK_DATA 
  #   doc = File.open(BOOK_DATA, 'rb:UTF-16le') { |f| Nokogiri::JSON(f) }
  # else
  #   doc = Nokogiri::JSON("")
  # end

  # @collections = JSON.parse(File.read(doc))

  @collections = JSON.parse(File.read("pjac.json"))


  error_ids = []
  created_ids = []
  updated_ids = []
  new_collection = nil

  @collections.each do |record|

    c = Collection.find_by(nid: record["Nid"])

    if c.nil?
      c = Collection.new(nid: record["Nid"], title: " ")
      new_collection = true
    end

    c.tap do |c|
      c.nid = record["Nid"],
      c.published = record["Published"],
      c.title = record["Title"],
      c.title_for_alphabetical_sorting = record["Title For Alphabetical Sorting"],
      c.collection_id = record["Collection Id"],
      c.collecting_area = record["Collecting Area"],
      c.date = record["Date"],
      c.type_of_material = record["Type of Material"],
      c.footage = record["Footage"],
      c.subjects = record["Subjects"],
      c.body = Loofah.fragment(record["Body"]).scrub!(:whitewash),
      c.index_terms = record["Index Terms"]
    end

    if c.save
      if !new_collection.nil?
        created_ids << c.id
      else
        updated_ids << c.nid
      end
    else
      error_ids << c.nid
    end

    puts "created: "+(created_ids.length).to_s+"\n"
    puts "updated: "+(updated_ids.length).to_s+"\n"
    puts "errors: "+error_ids.length.to_s

  end

end # collections
end # update
end # db
