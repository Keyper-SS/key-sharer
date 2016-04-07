require 'sinatra'
require 'json'
require 'base64'
require_relative 'models/key'

# Configuration Sharing Web Service
class ShareKeysAPI < Sinatra::Base
  before do
    Key.setup
  end

  get '/?' do
    'KeyShare web service is up and running at /api/v1'
  end
end
