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
    puts 'in authenticated_user function'
    scheme, auth_token = env['HTTP_AUTHORIZATION'].split(' ')
    puts "schem: #{scheme}"
    puts "auth_token: #{auth_token}"
    puts "userpayload: #{JSON.load JWE.decrypt(auth_token)}"
    user_payload = JSON.load JWE.decrypt(auth_token)
    (scheme =~ /^Bearer$/i) ? user_payload : nil
  end

  def authorized_user?(env, id)
    puts 'in authorized_user function'
    user = authenticated_user(env)
    puts id
    puts user['id']
    puts user['id'] == id.to_i
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
