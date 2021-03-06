require 'experian'
require 'minitest/autorun'
require 'minitest/pride'
require 'webmock/minitest'
require 'mocha/setup'
require 'timecop'

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(product, file)
  File.read("#{fixture_path}/#{product}/#{file}")
end

def stub_experian_uri_lookup
  Experian.user, Experian.password = 'user', 'password'
  stub_request(:get, Experian.ecals_uri.to_s).to_return(body: "http://fake.experian.com", status: 200)
end

def stub_experian_request(product, file)
  stub_experian_uri_lookup
  stub_request(:post, "http://user:password@fake.experian.com").to_return(body: fixture(product, file), status: 200)
end

Experian.configure do |config|
  config.eai = "X42PB93F"
  config.preamble = "FCD2"
  config.op_initials = "AB"
  config.subcode = "1968543"
  config.user = "user"
  config.password = "password"
  config.vendor_number = "P55"
  config.test_mode = true
end
