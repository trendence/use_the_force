require "spec_helper"
require "activeforce/base"

RSpec.describe Activeforce::Base do
  let(:client) { instance_double("Restforce::Client", query: [], find: nil) }

  before do
    allow(described_class).to receive(:client).and_return(client)
    described_class.table_name("CustomObject__c")
    described_class.fields(:Id, :Name, :Custom_Field__c)
  end

  describe ".all" do
    it "returns a Relation instance representing all records" do
      allow(client).to receive(:query).with("SELECT Id, Name, Custom_Field__c FROM CustomObject__c ").and_return([])
      result = described_class.all
      expect(result).to be_a(described_class::Relation)
    end
  end

  describe ".find" do
    let(:record_id) { "a1Xxx0000001gPQ" }
    let(:mock_response) { {"Id" => record_id, "Name" => "Test Name"} }

    before do
      allow(client).to receive(:find).with("CustomObject__c", record_id).and_return(mock_response)
    end

    it "fetches a record by its ID" do
      result = described_class.find(record_id)
      expect(result).to eq(mock_response)
    end
  end

  describe ".find!" do
    let(:record_id) { "nonexistent" }

    before do
      allow(client).to receive(:find).with("CustomObject__c", record_id)
        .and_raise(Restforce::NotFoundError.new(404, "Record not found"))
    end

    it "raises Restforce::NotFoundError if no record is found" do
      expect { described_class.find!(record_id) }.to raise_error(Restforce::NotFoundError) do |error|
        expect(error.response).to eq("Record not found")
      end
    end
  end

  describe ".find_by" do
    let(:mock_response) { [{"Id" => "001xx000003DG5ZAAW", "Name" => "John Doe"}] }

    before do
      allow(client).to receive(:query).and_return(mock_response)
    end

    it "returns the first record matching the conditions" do
      result = described_class.find_by(Id: "001xx000003DG5ZAAW")
      expect(result).to eq(mock_response.first)
    end

    it "returns nil if no record is found" do
      allow(client).to receive(:query).and_return([])
      result = described_class.find_by(Id: "nonexistent")
      expect(result).to be_nil
    end
  end

  describe ".find_by!" do
    it "raises RecordNotFound if no record is found" do
      allow(client).to receive(:query).and_return([])
      expect { described_class.find_by!(Id: "nonexistent") }.to raise_error(Activeforce::RecordNotFound)
    end
  end

  describe "fields and table_name class methods" do
    it "correctly sets and retrieves custom fields" do
      expect(described_class.read_fields).to include(:Id, :Name, :Custom_Field__c)
    end

    it "correctly sets and retrieves custom table name" do
      expect(described_class.read_table_name).to eq("CustomObject__c")
    end
  end
end
