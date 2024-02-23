require "spec_helper"
require "activeforce/base"

RSpec.describe Activeforce::Base do
  describe Activeforce::Base::Relation do
    let(:client) { instance_double("Restforce::Client", query: []) }

    # Create a dummy subclass for testing
    before(:all) do
      class SalesforceModel < Activeforce::Base
        fields :Id, :Name, :Custom_Field__c
        table_name "CustomObject__c"
      end
    end

    before do
      allow(Activeforce::Base).to receive(:client).and_return(client)
      allow(client).to receive(:query).and_return([])
    end

    describe ".where" do
      it "builds correct SOQL query with string conditions" do
        expected_query = "SELECT Id, Name, Custom_Field__c FROM CustomObject__c  WHERE Name = 'Example'"
        SalesforceModel.where(Name: "Example")
        expect(client).to have_received(:query).with(expected_query)
      end

      it "builds correct SOQL query with multiple conditions" do
        expected_query = "SELECT Id, Name, Custom_Field__c FROM CustomObject__c  WHERE Name = 'Example' AND Custom_Field__c = 123.45"
        SalesforceModel.where(Name: "Example", Custom_Field__c: 123.45)
        expect(client).to have_received(:query).with(expected_query)
      end

      it "handles boolean conditions correctly" do
        expected_query = "SELECT Id, Name, Custom_Field__c FROM CustomObject__c  WHERE Active__c = true"
        SalesforceModel.where(Active__c: true)
        expect(client).to have_received(:query).with(expected_query)
      end
    end
    after(:all) { Object.send(:remove_const, :SalesforceModel) }
  end

  # Cleanup to remove the dummy class after tests run

  describe ".all" do
    before do
      Activeforce::Base.table_name("CustomObject__c")
      Activeforce::Base.fields(:Id, :Name)
      mock_client = instance_double("Restforce::Client", query: [])
      allow(Activeforce::Base).to receive(:client).and_return(mock_client)
      allow(mock_client).to receive(:query).with("SELECT Id, Name FROM CustomObject__c ").and_return([])
    end
  
    it "returns a Relation instance representing all records" do
      result = Activeforce::Base.all
      expect(result).to be_a(Activeforce::Base::Relation)
    end
  end

  describe ".find_by" do
    let(:mock_response) { [{"Id" => "001xx000003DG5ZAAW"}] }

    before do
      allow(Activeforce::Base).to receive(:client).and_return(double("client", query: mock_response))
    end

    it "returns the first record matching the conditions" do
      expect(Activeforce::Base.find_by(Id: "001xx000003DG5ZAAW")).to eq(mock_response.first)
    end

    it "returns nil if no record is found" do
      allow(Activeforce::Base).to receive(:client).and_return(double("client", query: []))
      expect(Activeforce::Base.find_by(Id: "nonexistent")).to be_nil
    end
  end

  describe ".find_by!" do
    it "raises RecordNotFound if no record is found" do
      allow(Activeforce::Base).to receive(:client).and_return(double("client", query: []))
      expect { Activeforce::Base.find_by!(Id: "nonexistent") }.to raise_error(Activeforce::RecordNotFound)
    end
  end

  describe "fields and table_name class methods" do
    before do
      stub_const("SampleModel", Class.new(Activeforce::Base) do
        fields :Id, :Name, :Custom_Field__c
        table_name "CustomObject__c"
      end)
    end

    it "correctly sets and retrieves custom fields" do
      expect(SampleModel.read_fields).to include(:Id, :Name, :Custom_Field__c)
    end

    it "correctly sets and retrieves custom table name" do
      expect(SampleModel.read_table_name).to eq("CustomObject__c")
    end
  end
end
