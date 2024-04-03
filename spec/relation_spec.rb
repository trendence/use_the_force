require "spec_helper"
require "use_the_force/base"

RSpec.describe UseTheForce::Base::Relation do
  before do
    stub_const("SalesforceModel", Class.new(UseTheForce::Base) do
      fields :Id, :Name, :Custom_Field__c
      table_name "CustomObject__c"
    end)
  end

  let(:client) { instance_double("Restforce::Client", query: []) }

  before do
    allow(UseTheForce::Base).to receive(:client).and_return(client)
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
end
