# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' } { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
# require Rails.root.join("db/account_seeds.rb") if File.exists?("db/account_seeds.rb")

# Create FormInfo for AV duplication request form
unless FormInfo.exists?(slug: "av-requests")
  FormInfo.create!(
    title: "AV Duplication Request Form",
    slug: "av-requests",
    grouping: "",
    recipients: ["placeholder@temple.edu"],  # Not used since form saves to database only
    intro: "<h3 class='mt-4'>Payment</h3>
<ul>
<li>#{I18n.t('helpers.description.form.payment_intro')}</li>
<li>#{I18n.t('helpers.description.form.payment_methods')}</li>
<li>#{I18n.t('helpers.description.form.payment_check')}</li>
<li>#{I18n.t('helpers.description.form.payment_credit_card')}</li>
<li>#{I18n.t('helpers.description.form.payment_delivery')}</li>
</ul>"
  )
end

# Create FormInfo for Copy request form
unless FormInfo.exists?(slug: "copy-requests")
  FormInfo.create!(
    title: "Copy Request Form",
    slug: "copy-requests",
    grouping: "",
    recipients: ["placeholder@temple.edu"],  # Not used since form saves to database only
    intro: "<h3 class='mt-4'>Pricing Information</h3>
<ul>
<li>TIFF (600 DPI): $5 per image</li>
<li>PDF: $0.50 per page</li>
<li>Photocopy: $0.50 per page plus postage</li>
</ul>
<p><strong>Postage Information:</strong> Up to 100 pages: $5.00; Over 100 pages, USPS rate</p>"
  )
end
