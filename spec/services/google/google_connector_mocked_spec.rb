require 'google/apis/sheets_v4'
require "rails_helper"
require "ostruct"

RSpec.describe Google::SheetsConnector, type: :service do
	let(:spreadsheet_id) { 'test-spreadsheet-id' }
	let(:cells) { 'A2:A' }
	let(:response) do
		Google::Apis::SheetsV4::ValueRange.new(values: [['Header1'], ['Row1']])
	end
	let(:service) { instance_double(Google::Apis::SheetsV4::SheetsService) }
	let(:request_options) { instance_double(Google::Apis::RequestOptions, retries: 3) }

	before do
		allow(Rails.configuration).to receive(:hours_spreadsheet_id).and_return(spreadsheet_id)
		allow(Rails.configuration).to receive(:hours_spreadsheet_date_cells).and_return(cells)
		allow(Rails.configuration).to receive(:google_sheets_api_key).and_return('fake-api-key')

		# Mock Google Sheets service initialization
		allow(Google::Apis::SheetsV4::SheetsService).to receive(:new).and_return(service)
		allow(service).to receive(:key=)
		allow(service).to receive(:request_options=)

		# Simulate two errors followed by a successful response on the third try
    allow(service).to receive(:get_spreadsheet_values)
      .with(spreadsheet_id, cells)
      .and_raise(Google::Apis::TransmissionError).twice
    allow(service).to receive(:get_spreadsheet_values)
      .with(spreadsheet_id, cells)
      .and_return(response).at_least(:once)
		# allow(service).to receive(:get_spreadsheet_values).exactly(3).times 
	end

	subject { described_class.new(feature: "hours") }

	it 'retries twice on transmission errors and succeeds on the third attempt' do
		result = subject.call

		# Test the expected response
		expect(result).to eq(response)

		# Verify that the service was called exactly three times (2 failures + 1 success)
		expect(service).to have_received(:get_spreadsheet_values).exactly(3).times
	end
end