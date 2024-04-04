require "use_the_force/version"
require "use_the_force/base"
require "use_the_force/configuration"
require "restforce"

module UseTheForce
  extend Configuration

  class RecordNotFound < StandardError
  end

  define_configurables :username, :pw, :api_version, :client_id, :client_secret, :security_token, :instance_url

  @@username = ENV["SALESFORCE_USERNAME"]
  @@pw = ENV["SALESFORCE_PW"]
  @@api_version = ENV["SALESFORCE_API_VERSION"]
  @@client_id = ENV["SALESFORCE_CLIENT_ID"]
  @@client_secret = ENV["SALESFORCE_CLIENT_SECRET"]
  @@security_token = ENV["SALESFORCE_SECURITY_TOKEN"]
  @@instance_url = ENV["SALESFORCE_INSTANCE_URL"]
end
