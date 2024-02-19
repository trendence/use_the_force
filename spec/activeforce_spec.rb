# frozen_string_literal: true

require "spec_helper"
require "activeforce"

RSpec.describe Activeforce do
  describe ".configuration" do
    it "sets and retrieves configuration settings" do
      Activeforce.username = "example_username"
      Activeforce.pw = "example_password"
      Activeforce.api_version = "example_api_version"
      Activeforce.client_id = "example_client_id"
      Activeforce.client_secret = "example_client_secret"
      Activeforce.security_token = "example_security_token"
      Activeforce.instance_url = "example_instance_url"
      # Continue for other settings

      expect(Activeforce.username).to eq("example_username")
      expect(Activeforce.pw).to eq("example_password")
      expect(Activeforce.api_version).to eq("example_api_version")
      expect(Activeforce.client_id).to eq("example_client_id")
      expect(Activeforce.client_secret).to eq("example_client_secret")
      expect(Activeforce.security_token).to eq("example_security_token")
      expect(Activeforce.instance_url).to eq("example_instance_url")
    end
  end
end
