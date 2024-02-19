# Activeforce

Ruby wrapper to mimick parts of ActiveRecord query interface to obtain
data conveniently (and human friendly 😅) from Salesforce RESTful API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activeforce'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install activeforce

## Usage

Put your authentication credentials in an initializer:
```ruby
Activeforce.configuration do |config|
  config.username = ENV["SALESFORCE_USERNAME"]
  config.pw = ENV["SALESFORCE_PW"]
  config.api_version = ENV["SALESFORCE_API_VERSION"]
  config.client_id = ENV["SALESFORCE_CLIENT_ID"]
  config.client_secret = ENV["SALESFORCE_CLIENT_SECRET"]
  config.security_token = ENV["SALESFORCE_SECURITY_TOKEN"]
  config.instance_url = ENV["SALESFORCE_INSTANCE_URL"]
end
```

Define your Salesforce models:
```ruby
class Salesforce::User < Activeforce::Base
  fields :Email, :Name, :IsPirate__c
  table_name :User__c
end
```

Lookup records in a similar fashion like `ActiveRecord`, for example,
you can use `find_by`:

```ruby
user = Salesforce::User.find_by(Email: "guybrush.threepwood@absolventa.de")
user.Name # Guybrush Threepwood
```

… or `where` for filering:

```ruby
pirates = Salesforce::Pirate.where(Flag__c: "black").where(HasWoodenLeg: false).all
pirates.count # 42
```
