# frozen_string_literal: true

require "spec_helper"
require "use_the_force"

RSpec.describe UseTheForce do
  describe ".configuration" do
    it "sets and retrieves configuration settings" do
      UseTheForce.username = "example_username"
      UseTheForce.pw = "example_password"
      UseTheForce.api_version = "example_api_version"
      UseTheForce.client_id = "example_client_id"
      UseTheForce.client_secret = "example_client_secret"
      UseTheForce.security_token = "example_security_token"
      UseTheForce.instance_url = "example_instance_url"
      # Continue for other settings

      expect(UseTheForce.username).to eq("example_username")
      expect(UseTheForce.pw).to eq("example_password")
      expect(UseTheForce.api_version).to eq("example_api_version")
      expect(UseTheForce.client_id).to eq("example_client_id")
      expect(UseTheForce.client_secret).to eq("example_client_secret")
      expect(UseTheForce.security_token).to eq("example_security_token")
      expect(UseTheForce.instance_url).to eq("example_instance_url")
    end
  end
end
