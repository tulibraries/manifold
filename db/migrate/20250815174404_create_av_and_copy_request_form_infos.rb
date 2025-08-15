class CreateAvAndCopyRequestFormInfos < ActiveRecord::Migration[7.2]
  def up
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
  end

  def down
    FormInfo.where(slug: ["av-requests", "copy-requests"]).destroy_all
  end
end
