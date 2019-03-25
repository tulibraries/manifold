# frozen_string_literal: true

require "json"

namespace :db do
  namespace :populate do

  desc "separate files"
  task :run_updates, [:file_path] => :environment do |t, args|
    filepath = args.fetch(:file_path, nil)
    if filepath && File.exist?(filepath)
      Rake::Task["db:seed:finding_aids"].invoke(filepath)
    end
  end

  desc "Pull in Finding Aids from Drupal Export"
  task :finding_aids, [:filepath] => :environment do |t, args|

  doc = args.fetch(:filepath, nil)

  @aids = JSON.parse(File.read(doc))

  error_ids = []
  created_ids = []
  updated_ids = []
  new_collection = nil

  @aids.each do |record|

    c = FindingAid.find_by(drupal_id: record["Nid"])

    if c.nil?
      c = FindingAid.new(drupal_id: record["Nid"], name: " ")
      new_collection = true
    end

    # c.published = record["Published"]
    # c.index_terms = record["Index Terms"].split(', ').map{ |term| term }
    # c.title_for_alphabetical_sorting = record["Title For Alphabetical Sorting"]
    # c.date = record["Date"]
    # c.type_of_material = record["Type of Material"].split(', ').map{ |type| type }
    # c.footage = record["Footage"]
    c.name = record["Title"]
    c.identifier = record["Collection ID"]
    c.subject = record["Subjects"].split(", ").collect { |s| s }
    c.collection_ids = record["Collecting Area"].split("| ").collect { |c| collection_id(c) }
    c.description = Loofah.fragment(record["Body"]).scrub!(:whitewash)

    if c.save
      if new_collection == true
        created_ids << c.drupal_id
      else
        updated_ids << c.drupal_id
      end
    else
      # binding.pry
      error_ids << c.drupal_id
    end

    new_collection = false

  end

  puts "created: " + (created_ids.length).to_s + "\n"
  puts "updated: " + (updated_ids.length).to_s + "\n"
  puts "errors: " + error_ids.length.to_s

end # collections

  def collection_id(name)
    case  name
    when "Contemporary Culture Collections"
      1
    when "Manuscripts and Archives"
      2
    when "Paskow Science Fiction Collection (Science Fiction and Fantasy)"
      3
    when "Philadelphia Dance Collection"
      4
    when "Philadelphia Jewish Archives Collection"
      5
    when "Printing, Publishing, and Bookselling Collections"
      6
    when "Rare Books"
      7
    when "University Archives"
      8
    when "Urban Archives"
      9
    when "Charles L. Blockson Afro-American Collection"
      10
    else
      # binding.pry
      nil
    end
  end

end # update
end # db
