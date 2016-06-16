require 'sinatra'
require 'json'
require 'rack/ssl-enforcer'

# Configuration Sharing Web Service
class ShareKeysAPI < Sinatra::Base
  enable :logging

  configure :production do
    use Rack::SslEnforcer
  end

  def authenticated_user(env)
    scheme, auth_token = env['HTTP_AUTHORIZATION'].split(' ')
    user_payload = JSON.load SecureClientMessage.decrypt(auth_token)
    (scheme =~ /^Bearer$/i) ? user_payload : nil
  end

  def authorized_user?(env, id)
    user = authenticated_user(env)
    user['id'] == id.to_i
  rescue
    false
  end

  before do
    host_url = "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    @request_url = URI.join(host_url, request.path.to_s)
  end

  get '/?' do
    'KeyShare web service is up and running at /api/v1'
  end
end
