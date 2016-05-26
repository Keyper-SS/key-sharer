ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
Dir.glob('./{config,lib,models,services,controllers}/init.rb').each do |file|
  require file
end

include Rack::Test::Methods

def app
  ShareKeysAPI
end

def invalid_id(resource)
  case [resource]
  when [User]
    (resource.max(:id) || 0) + 1
  when [Secret]
    (resource.max(:id) || 0) + 1
  else
    raise "INVALID_ID: unknown primary key for #{resource}"
  end
end

def random_str(size)
  chars = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
  chars.sample(size).join
end
