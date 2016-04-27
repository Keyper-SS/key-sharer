require 'sinatra'
require 'json'

# Configuration Sharing Web Service
class ShareKeysAPI < Sinatra::Base
  before do
    host_url = "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    @request_url = URI.join(host_url, request.path.to_s)
  end

  get '/?' do
    'KeyShare web service is up and running at /api/v1'
  end
end
