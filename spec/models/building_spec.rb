require 'rails_helper'

RSpec.describe Building, type: :model do
  context 'Building Class Attributes' do
    subject { Building.new.attributes.keys }

    it { is_expected.to include("name") }
    it { is_expected.to include("description") }
    it { is_expected.to include("description") }
    it { is_expected.to include("name") }
    it { is_expected.to include("description") }
    it { is_expected.to include("address1") }
    it { is_expected.to include("temple_building_code") }
    it { is_expected.to include("directions_map") }
    it { is_expected.to include("hours") }
    it { is_expected.to include("phone_number") }
    it { is_expected.to include("image") }
    it { is_expected.to include("campus") }
    it { is_expected.to include("accessibility") }
    it { is_expected.to include("email") }
  end
end
