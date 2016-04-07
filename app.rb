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

  get '/api/v1/keys/?' do
    content_type 'application/json'
    id_list = Key.all

    { key_id: id_list }.to_json
  end

  get '/api/v1/keys/:key_id.json' do
    content_type 'application/json'

    begin
      { key: Key.find(params[:key_id]) }.to_json
    rescue => e
      status 404
      logger.info "FAILED to GET key: #{e.inspect}"
    end
  end

  # - POST `/api/v1/keys/?`:
  post '/api/v1/keys/?' do
    content_type 'application/json'

    begin
      new_data = JSON.parse(request.body.read)
      logger.info new_data
      new_key = Key.new(new_data)
      if new_key.save
        logger.info "NEW KEY STORED: #{new_key.id}"
      else
        halt 400, "Could not store key: #{new_key}"
      end

      redirect '/api/v1/keys/' + new_key.id + '.json'
    rescue => e
      status 400
      logger.info "FAILED to create new key: #{e.inspect}"
    end
  end
end
