require "spec_helper"
require "activeforce/base"

RSpec.describe Activeforce::Base do
  describe Activeforce::Base::Relation do
    describe "#where" do
      let(:client) { instance_double("Restforce::Client") }
      let(:target_class) do
        Class.new do
          def self.read_fields
            [:Id, :Name, :Custom_Field__c]
          end

          def self.read_table_name
            "CustomObject__c"
          end
        end
      end

      it "builds correct SOQL query with string conditions" do
        relation = described_class.new(client, target: target_class).where(Name: "Example")
        expect(relation.instance_variable_get(:@soql)).to eq("SELECT Id, Name, Custom_Field__c FROM CustomObject__c  WHERE Name = 'Example'")
      end

      it "builds correct SOQL query with multiple conditions" do
        relation = described_class.new(client, target: target_class).where(Name: "Example", Custom_Field__c: 123.45)
        expect(relation.instance_variable_get(:@soql)).to eq("SELECT Id, Name, Custom_Field__c FROM CustomObject__c  WHERE Name = 'Example' AND Custom_Field__c = 123.45")
      end

      it "handles boolean conditions correctly" do
        relation = described_class.new(client, target: target_class).where(Active__c: true)
        expect(relation.instance_variable_get(:@soql)).to eq("SELECT Id, Name, Custom_Field__c FROM CustomObject__c  WHERE Active__c = true")
      end
    end
  end

  describe ".all" do
    before do
      Activeforce::Base.table_name("CustomObject__c")
      Activeforce::Base.fields(:Id, :Name)
    end

    it "returns a Relation instance representing all records" do
      allow_any_instance_of(Activeforce::Base::Relation).to receive(:query).and_return([])
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
