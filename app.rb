require 'sinatra'
require 'json'
require_relative 'config/environments'
require_relative 'models/init'
require_relative 'services/init'

# Configuration Sharing Web Service
class ShareKeysAPI < Sinatra::Base
  before do
    host_url = "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    @request_url = URI.join(host_url, request.path.to_s)
  end

  get '/?' do
    'KeyShare web service is up and running at /api/v1'
  end

  get '/api/v1/users/?' do
    content_type 'application/json'

    JSON.pretty_generate(data: User.all)
  end

  get '/api/v1/users/:user_username' do
    content_type 'application/json'

    user_username = params[:user_username]
    user = User.where(username: user_username).first
    secrets = user ? User[user.id].owned_secrets : []

    if user
      JSON.pretty_generate(data: user, relationships: secrets)
    else
      halt 404, "USER NOT FOUND: #{user_username}"
    end
  end

  post '/api/v1/users/?' do
    begin
      user_data = JSON.parse(request.body.read)
      saved_user = CreateUser.call(
                    username: user_data['username'],
                    email: user_data['email'],
                    password: user_data['password'])
    rescue => e
      logger.info "FAILED to create new user: #{e.inspect}"
      halt 400
    end

    new_location = URI.join(@request_url.to_s + '/', saved_user.username.to_s)
                      .to_s

    status 201
    headers('Location' => new_location)
  end

  get '/api/v1/users/:user_username/secrets/?' do
    content_type 'application/json'
    user_username = params[:user_username]
    user = User.where(username: user_username).first
    owned_secrets = user ? User[user.id].owned_secrets : []
    shared_secrets = user ? User[user.id].shared_secrets : []
    received_secrets = user ? User[user.id].received_secrets : []

    if user
      JSON.pretty_generate(data: user, secrets: { owned: owned_secrets,
                                                  shared: shared_secrets,
                                                  received: received_secrets })
    else
      halt 404, "ACCOUNT NOT FOUND: #{user_username}"
    end
  end

  get '/api/v1/users/:user_username/secrets/:secret_id/?' do
    content_type 'application/json'
    secret_find = nil
    user_username = params[:user_username]
    user = User.where(username: user_username).first

    owned_secrets = user ? User[user.id].owned_secrets : []
    owned_secrets.each do |secret|
      if Integer(secret.id) == Integer(params[:secret_id])
        secret_find = secret
      end
    end

    if secret_find
      JSON.pretty_generate(data: secret_find)
    else
      halt 404, "SECRET NOT FOUND OR NOT AUTHORIZED TO READ: #{user_username}"
    end
  end

  post '/api/v1/users/:user_username/secrets/?' do
    begin
      secret_data = JSON.parse(request.body.read)
      secret = CreateSecret.call(title: secret_data['title'],
                          description: secret_data['description'],
                          username: params[:user_username],
                          account: secret_data['account'],
                          password: secret_data['password'])
    rescue => e
      logger.info "FAILED to create new secret: #{e.inspect}"
      halt 400
    end

    new_location = URI.join(@request_url.to_s + '/', secret.id.to_s)
                      .to_s

    status 201
    headers('Location' => new_location)
  end
end
