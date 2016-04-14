require 'sinatra'
require 'json'
require 'base64'
require_relative 'config/environments'
require_relative 'models/init'

# Configuration Sharing Web Service
class ShareKeysAPI < Sinatra::Base
  before do
    Key.setup
  end

  get '/?' do
    'KeyShare web service is up and running at /api/v1'
  end

  get '/api/v1/accounts/?' do
  end

  get '/api/v1/accounts/:key_id.json' do
  end

  post '/api/v1/accounts/?' do
  end

  get '/api/v1/keys/?' do
  end

  get '/api/v1/keys/:key_id.json' do
  end

  post '/api/v1/keys/?' do
  end
end
