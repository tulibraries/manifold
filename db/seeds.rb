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
    grouping: "No Grouping",
    recipients: ["scrc@temple.edu"],
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
    title: "Request Copies",
    slug: "copy-requests",
    grouping: "No Grouping",
    recipients: ["scrc@temple.edu"],
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
