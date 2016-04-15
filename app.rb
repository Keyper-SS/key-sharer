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

  get '/api/v1/accounts/?' do
    content_type 'application/json'

    JSON.pretty_generate(data: Account.all)
  end

  get '/api/v1/accounts/:account_username' do
    content_type 'application/json'

    account_username = params[:account_username]
    account = Account.where(username: account_username).first
    secrets = account ? Account[account.id].secrets : []

    if account
      JSON.pretty_generate(data: account, relationships: secrets)
    else
      halt 404, "PROJECT NOT FOUND: #{account_username}"
    end
  end

  post '/api/v1/accounts/?' do
    begin
      new_data = JSON.parse(request.body.read)
      saved_account = Account.create(new_data)
    rescue => e
      logger.info "FAILED to create new project: #{e.inspect}"
      halt 400
    end

    new_location = URI.join(@request_url.to_s + '/', saved_account.username.to_s)
                      .to_s

    status 201
    headers('Location' => new_location)
  end

  get '/api/v1/accounts/:account_username/secrets/?' do
    content_type 'application/json'
    account_username = params[:account_username]
    account = Account.where(username: account_username).first
    secrets_owned = account ? Account[account.id].secrets : []
    secrets_shared = account ? Account[account.id].secrets_shared : []
    secrets_received = account ? Account[account.id].secrets_received : []

    if account
      JSON.pretty_generate(data: account, keys: { owned: secrets_owned , shared: secrets_shared , received: secrets_received})
    else
      halt 404, "ACCOUNT NOT FOUND: #{account_username}"
    end
  end

  get '/api/v1/accounts/:account_username/secrets/:secret_id' do
    content_type 'application/json'
    secret = nil
    account_username = params[:account_username]
    account = Account.where(username: account_username).first
    secrets_owned = account ? Account[account.id].secrets : []
    secrets_owned.each do |key|
      if Integer(key.id) == Integer(params[:key_id])
        secret = key
      end
    end

    if !secret
      secrets_received = account ? Account[account.id].secrets_received : []
      secrets_received.to_a.each do |key|
        if Integer(key.id) == Integer(params[:key_id])
          secret = key
        end
      end
    end

    if secret
      JSON.pretty_generate(data: secret)
    else
      halt 404, "SECRET NOT FOUND OR YOU ARE NOT AUTHORIZED TO READ: #{account_username}"
    end
  end

  post '/api/v1/accounts/:account_username/secrets/?' do
    begin
      new_data = JSON.parse(request.body.read)
      saved_secret = Secret.create(new_data)
    rescue => e
      logger.info "FAILED to create new secret: #{e.inspect}"
      halt 400
    end

    new_location = URI.join(@request_url.to_s + '/', saved_secret.id.to_s)
                      .to_s

    status 201
    headers('Location' => new_location)
  end
end
