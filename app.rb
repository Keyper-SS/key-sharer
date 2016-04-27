require 'sinatra'
require 'json'
require_relative 'config/environments'
require_relative 'models/init'

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
    secrets = user ? User[user.id].secrets : []

    if user
      JSON.pretty_generate(data: user, relationships: secrets)
    else
      halt 404, "USER NOT FOUND: #{user_username}"
    end
  end

  post '/api/v1/users/?' do
    begin
      user_data = JSON.parse(request.body.read)
      saved_user = User.new(email: user_data['email'], username: user_data['username'])
      saved_user.password = user_data['password']
      saved_user.save
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
    secrets_owned = user ? User[user.id].secrets : []
    secrets_shared = user ? User[user.id].secrets_shared : []
    secrets_received = user ? User[user.id].secrets_received : []

    if user
      JSON.pretty_generate(data: user, secrets: { owned: secrets_owned,
                                                  shared: secrets_shared,
                                                  received: secrets_received })
    else
      halt 404, "ACCOUNT NOT FOUND: #{user_username}"
    end
  end

  get '/api/v1/users/:user_username/secrets/:secret_id/?' do
    content_type 'application/json'
    secret_find = nil
    user_username = params[:user_username]
    user = User.where(username: user_username).first

    secrets_owned = user ? User[user.id].secrets : []
    secrets_owned.each do |secret|
      if Integer(secret.id) == Integer(params[:secret_id])
        secret_find = secret
      end
    end

    if secret_find
      JSON.pretty_generate(data: secret_find)
    else
      halt 404, "SECRET NOT FOUND OR YOU ARE NOT AUTHORIZED TO READ: #{user_username}"
    end
  end

  post '/api/v1/users/:user_username/secrets/?' do
    begin
      secret_data = JSON.parse(request.body.read)
      saved_secret = Secret.new(title: secret_data['title'],
                                description: secret_data['description'])

      user_username = params[:user_username]
      user = User.where(username: user_username).first
      saved_secret.user_id = user.id

      saved_secret.account = secret_data['account']
      saved_secret.password = secret_data['password']
      saved_secret.save
    rescue => e
      logger.info "FAILED to create new secret: #{e.inspect}"
      halt 400
    end

    new_location = URI.join(@request_url.to_s + '/', saved_secret.id.to_s)
                      .to_s

    status 201
    headers('Location' => new_location)
  end

  post '/api/v1/accounts/:account_username/keys/:key_id/share' do
    begin
      new_data = JSON.parse(request.body.read)
      saved_secret = Sharing.create(new_data)
    rescue => e
      logger.info "FAILED to share key: #{e.inspect}"
      halt 400
    end

    new_location = URI.join("/api/v1/accounts/:account_username/keys/")
                      .to_s

    status 201
    headers('Location' => new_location)
  end
end
