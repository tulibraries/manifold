module InputCleaner
  extend ActiveSupport::Concern

  def normalize_phone_number
    phone_number.gsub!(/\D/, "")
  end
end
