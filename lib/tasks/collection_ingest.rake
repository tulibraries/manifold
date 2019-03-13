# frozen_string_literal: true

# require 'open-uri'
# require 'nokogiri'
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
  task :finding_aids, [:filepath] => :environment do |t, args|

  doc = args.fetch(:filepath, nil)

  @collections = JSON.parse(File.read("pjac.json"))

  error_ids = []
  created_ids = []
  updated_ids = []
  new_collection = nil

  @collections.each do |record|

    c = FindingAid.find_by(drupal_id: record["Nid"])

    if c.nil?
      c = FindingAid.new(drupal_id: record["Nid"], name: " ")
      new_collection = true
    end

    # c.published = record["Published"]
    # c.index_terms = record["Index Terms"]
    # c.title_for_alphabetical_sorting = record["Title For Alphabetical Sorting"]
    # c.date = record["Date"]
    # c.type_of_material = record["Type of Material"]
    # c.footage = record["Footage"]
    c.name = record["Title"]
    c.identifier = record["Collection ID"]
    c.subject = record["Subjects"].split(',').map{|s| Rails::Html::FullSanitizer.new.sanitize(s)}
    c.collection_id = collection_id(Rails::Html::FullSanitizer.new.sanitize(record["Collecting Area"]))
    c.description = Loofah.fragment(record["Body"]).scrub!(:whitewash)

    if c.save
      if new_collection == true
        created_ids << c.drupal_id
      else
        updated_ids << c.drupal_id
      end
    else
      binding.pry
      error_ids << c.drupal_id
    end

    new_collection = false

  end

  puts "created: "+(created_ids.length).to_s+"\n"
  puts "updated: "+(updated_ids.length).to_s+"\n"
  puts "errors: "+error_ids.length.to_s

end # collections

  def collection_id(name)
    case  name
    when "Philadelphia Jewish Archives"
      1
    when "Manuscripts and Archives Collection"
      2
    when "Paskow Science Fiction Collection"
      3
    when "Philadelphia Dance Collection"
      4
    when "Philadelphia Jewish Archives Collection"
      5
    when "Printing, Publishing, and Bookselling Collections"
      6
    when "Rare Books"
      7
    when "Conwellana-Templana Collection: University Archive"
      8
    when "Urban Archives"
      9
    else
      nil
    end
  end

end # update
end # db
