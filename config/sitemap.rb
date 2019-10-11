# frozen_string_literal: true

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = ActionDispatch::Http::URL.url_for(Rails.application.routes.default_url_options)

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path "/" and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don"t specify)
  #
  # Defaults: :priority => 0.5, :changefreq => "weekly",
  #           lastmod: Time.now, :host => default_host
  #
  # Examples:
  #
  # Add "/articles"
  #
  #   add articles_path, :priority => 0.7, :changefreq => "daily"
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), lastmod: article.updated_at
  #   end

  #snowflakes
  add "/about"
  add "/visit-study"
  add "/explore-charles"
  add "/research-services"
  add "/blockson"
  add "/contact"
  add "/hsl"
  add "/scrc"
  add "/lcdss"
  add "/"
  add "/hours"

  #indices
  add forms_path
  add people_path
  add events_path

  #show pages
  Collection.find_each do |collection|
    add collection_path(collection), lastmod: collection.updated_at
  end
  FindingAid.find_each do |finding_aid|
    add finding_aid_path(finding_aid), lastmod: finding_aid.updated_at
  end
  Exhibition.find_each do |exhibition|
    add exhibition_path(exhibition), lastmod: exhibition.updated_at
  end
  Policy.find_each do |policy|
    add policy_path(policy), lastmod: policy.updated_at
  end
  Service.find_each do |service|
    add service_path(service), lastmod: service.updated_at
  end
  Space.find_each do |space|
    add space_path(space), lastmod: space.updated_at
  end
  Person.find_each do |person|
    add person_path(person), lastmod: person.updated_at
  end
  Event.find_each do |event|
    add event_path(event), lastmod: event.updated_at
  end
  Building.find_each do |building|
    add building_path(building), lastmod: building.updated_at
  end
end
