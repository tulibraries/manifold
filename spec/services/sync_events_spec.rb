# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncService::Events, type: :service do
  before(:all) do
    @sync_events = described_class.new(events_url: file_fixture("events.xml").to_path)
    @events = @sync_events.read_events
  end

  context "valid events" do

    it "extracts the event hash" do
      expect(@events.first["Title"]).to match(/^Data Transparency: Policies and Best Practices$/)
    end

    it "extracts all of the events" do
      expect(@events.count).to equal(38)
    end

    describe "maps events xml to db schema" do
      subject { @sync_events.record_hash(@events.first) }

      it "maps GUID to guid field" do
        expect(subject["guid"]).to match(@events.first["GUID"])
      end

      it "maps Title to title field" do
        expect(subject["title"]).to match(@events.first["Title"])
      end

      it "maps Description to description field" do
        expect(subject["description"]).to match(@events.first["Description"])
      end

      it "maps EventStartDate and EventStartTime to start_time field" do
        expect(Time.zone.parse(subject["start_time"])).to eq(Time.zone.parse(@events.first["EventStartDate"] + " " + @events.first["EventStartTime"]))
      end

      it "maps EventEndDate and EventEndTime to start_time field" do
        expect(Time.zone.parse(subject["end_time"])).to eq(Time.zone.parse(@events.first["EventEndDate"] + " " + @events.first["EventEndTime"]))
      end

      it "maps AllDay to all_day field" do
        expect(subject["all_day"]).to_not be
      end

      it "maps Location to external_building field" do
        expect(subject["external_building"]).to match(@events.first["LocationUnaffiliated"])
      end

      it "maps Address to external_building field" do
        expect(subject["external_address"]).to match(@events.first["AddressUnaffiliated"])
      end

      it "maps City to external_building field" do
        expect(subject["external_city"]).to match(@events.first["CityUnaffiliated"])
      end

      it "maps State to external_state field" do
        expect(subject["external_state"]).to match(@events.first["StateUnaffiliated"])
      end

      it "maps Zip to external_zip field" do
        expect(subject["external_zip"]).to match(@events.first["ZipUnaffiliated"])
      end

      it "maps ContactName to external_contact_name field" do
        expect(subject["external_contact_name"]).to match(@events.first["ContactName"])
      end

      it "maps ContactEmail to external_contact_email field" do
        expect(subject["external_contact_email"]).to match(@events.first["ContactEmail"])
      end

      it "maps ContactPhone to external_contact_phone field" do
        expect(subject["external_contact_phone"]).to match(@events.first["ContactPhone"])
      end

      it "maps Canceled to cancelled field" do
        expect(subject["cancelled"]).to match(@events.first["Canceled"])
      end

      it "maps RegistrationStatus to registration_status field" do
        expect(subject["registration_status"]).to match(@events.first["RegistrationStatus"])
      end

      it "maps document's digest to content_has field" do
        expect(subject["content_hash"]).to match(Digest::SHA1.hexdigest(@events.first[:xml]))
      end
    end
  end

  context "write event to event table" do
    before(:each) do
      @sync_events.sync
    end

    let (:students_event) {
      Event.find_by(title: "Students, Labor Activism, and Publishing: From Radical America to Jacobin")
    }

    let(:data_event) {
      Event.find_by(title: "Data Transparency: Policies and Best Practices")
    }

    it "syncs events to the table" do
      expect(data_event).to be
      expect(students_event).to be
    end

    xit "it attaches images to records" do
      # TODO: need to mock the images urls in the xml
      expect(students_event.image.attached?).to be true
    end
  end

  context "fuzzy logic" do
    let(:internal_events) { described_class.new(events_url: file_fixture("fuzzy_events_internal.xml").to_path) }
    let(:external_events) { described_class.new(events_url: file_fixture("fuzzy_events_external.xml").to_path) }

    before(:example) do
      @building = FactoryBot.create(:building)
      @space = FactoryBot.create(:space, building: @building)
      @person = FactoryBot.create(:person, buildings: [@building])
      # create law library to ensure that the Paley Library event does not match
      @law = FactoryBot.create(:building, name: "Law Library")
    end

    describe "contact" do
      it "has a person reference" do
        allow(::FuzzyFind::Person).to receive(:find).with(kind_of(String)).and_return(@person)
        internal_events.sync
        event = Event.find_by(person_id: @person.id)
        expect(event.person_id).to eq @person.id
        expect(event.external_contact_name).to eq nil
      end
      it "doesn't have a person reference" do
        allow(::FuzzyFind::Person).to receive(:find).with(kind_of(String)).and_return(nil)
        external_events.sync
        event = Event.find_by(person_id: @person.id)
        expect(event).to_not be
      end
    end

    describe "location/building" do
      it "has a building reference" do
        allow(::FuzzyFind::Building).to receive(:find)
          .with(kind_of(String), kind_of(Hash))
          .and_return(@building)

        internal_events.sync
        event = Event.find_by(building_id: @building.id)
        expect(event.building_id).to eq @building.id
        expect(event.building.name).to eq @building.name
        expect(event.external_building).to eq nil
      end
      it "doesn't have a building reference" do
        allow(::FuzzyFind::Building).to receive(:find)
          .with(kind_of(String), kind_of(Hash))
          .and_return(nil)
        external_events.sync
        event = Event.find_by(building_id: @building.id)
        expect(event).to_not be
      end
    end

    context "space" do
      it "has a space reference" do
        allow(::FuzzyFind::Space).to receive(:find).with(kind_of(String), anything).and_return(@space)
        internal_events.sync
        event = Event.find_by(space_id: @space.id)
        expect(event.space_id).to eq @space.id
        expect(event.space.name).to eq @space.name
        expect(event.external_space).to eq nil
      end
      it "doesn't have a space reference" do
        allow(::FuzzyFind::Space).to receive(:find).with(kind_of(String), anything).and_return(nil)
        external_events.sync
        event = Event.find_by(space_id: @space.id)
        expect(event).to_not be
      end
    end
  end

  context "trying to ingest the same record twice" do
    let(:sync_event) { described_class.new(events_url: file_fixture("single_event.xml").to_path) }

    it "does not update the record" do
      sync_event.sync
      first_time = Event.find_by(title: "BLAH BLAH Foo foo").updated_at
      sync_event.sync
      second_time = Event.find_by(title: "BLAH BLAH Foo foo").updated_at
      expect(first_time).to eql second_time
    end

    it "does not throw an error trying to attach image twice" do
      sync_event.sync
      expect { sync_event.sync }.not_to raise_error
    end


  end

  context "when sync is forced" do
    let(:sync_event) { described_class.new(events_url: file_fixture("single_event.xml").to_path) }
    let(:force_sync_event) { described_class.new(events_url: file_fixture("single_event.xml").to_path, force: true) }

    it "updates the record" do
      sync_event.sync
      first_time = Event.find_by(title: "BLAH BLAH Foo foo").updated_at
      force_sync_event.sync
      second_time = Event.find_by(title: "BLAH BLAH Foo foo").updated_at
      expect(second_time).to be > first_time
    end
  end

  context "all day event" do
    let(:sync_event) { described_class.new(events_url: file_fixture("single_event.xml").to_path) }
    subject { @sync_events.record_hash(@events.last) }

    it "maps AllDay to all_day field" do
      expect(subject["all_day"]).to be
    end
  end

  context "trying to ingest an existing record with slight changes" do
    let(:sync_event) { described_class.new(events_url: file_fixture("single_event.xml").to_path) }
    let(:altered_event) { described_class.new(events_url: file_fixture("single_altered_event.xml").to_path) }

    it "does not update the record" do
      sync_event.sync
      original_rec_id = Event.find_by(title: "BLAH BLAH Foo foo").id
      altered_event.sync
      updated_rec_id = Event.find_by(title: "*CANCELLED* BLAH BLAH Foo foo").id
      expect(original_rec_id).to eql updated_rec_id
    end
  end

  context "Error in field" do
    before (:each) { @starting_event_count = Event.count }
    describe "no images specified" do
      let (:sync_events) { described_class.new(events_url: file_fixture("noimage-event.xml").to_path) }

      it "should not raise error if an image is missing" do
        expect { sync_events.sync }.to_not raise_error
      end

      it "should add the event" do
        sync_events.sync
        expect(Event.count).to eq (@starting_event_count + 1)
      end
    end

    describe "erroneous images specified" do
      context "unit level" do
        let (:sync_events) { described_class.new(events_url: file_fixture("badimage-event.xml").to_path) }

        it "should not raise error if an image URL is bad" do
          expect { sync_events.sync }.to_not raise_error
        end

        it "should not add the event" do
          sync_events.sync
          expect(Event.count).to eq @starting_event_count
        end
      end

      context "feed level" do
        let (:sync_events) { described_class.new(events_url: file_fixture("events-onebad.xml").to_path) }

        it "should add subsequent valid events" do
          sync_events.sync
          expect(Event.count).to eq (@starting_event_count + 1)
        end
      end
    end
  end

  context "sync timeout" do
    let(:feed_url) { "https://example.com/events/feed.xml" }

    xit "passes timeout to http request" do
      skip("ruby 3.1.2 -- options hash no longer works: 'no implicit conversion of Hash into String'")
      expect(URI).to receive(:open).with(feed_url, { read_timeout: Rails.configuration.sync_timeout })
      sync_events = described_class.new(events_url: feed_url)
    end
  end
end
