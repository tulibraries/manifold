# frozen_string_literal: true

MIGRATION_CLASS =
  if ActiveRecord::VERSION::MAJOR >= 5
    ActiveRecord::Migration["#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}"]
  else
    ActiveRecord::Migration
  end

class CreateFriendlyIdSlugs < MIGRATION_CLASS
  def change
    create_table :friendly_id_slugs do |t|
      t.string   :slug,           null: false
      t.integer  :sluggable_id,   null: false
      t.string   :sluggable_type, limit: 50
      t.string   :scope
      t.datetime :created_at
    end
    add_index :friendly_id_slugs, [:sluggable_type, :sluggable_id]
    add_index :friendly_id_slugs, [:slug, :sluggable_type], length: { slug: 140, sluggable_type: 50 }
    add_index :friendly_id_slugs, [:slug, :sluggable_type, :scope], length: { slug: 70, sluggable_type: 50, scope: 70 }, unique: true

    @log = Logger.new("log/slug-fest.log")
    entities = [Blog, Building, Category, Collection, Event, Exhibition, ExternalLink, FindingAid, Group, Highlight, Webpage, Person, Policy, Service, Space]

    entities.each do |e|
      e.all.each do |a|
        a.with_lock do
          #   #@log.send(:info, "#{a.class.name}: #{a.label} -- slug  not blank -- slug = '#{a.slug}'") if !a.slug.blank?
          a.slug = nil if a.slug == ""
          begin
            a.save! if a.slug.nil?
          rescue StandardError => e
            @log.send(:info, "#{a.class.name}: #{a.label} -- #{e.message}")
            next
          end
        end
      end
    end
  end
end
