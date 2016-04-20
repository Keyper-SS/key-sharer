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

    JSON.pretty_generate(data: User.all)
  end

  get '/api/v1/accounts/:account_username' do
    content_type 'application/json'

    account_username = params[:account_username]
    account = User.where(username: account_username).first
    secrets = account ? User[account.id].secrets : []

    if account
      JSON.pretty_generate(data: account, relationships: secrets)
    else
      halt 404, "PROJECT NOT FOUND: #{account_username}"
    end
  end

  post '/api/v1/accounts/?' do
    begin
      new_data = JSON.parse(request.body.read)
      saved_account = User.new(email: new_data["email"])
      saved_account.username = new_data["username"]
      saved_account.password_encrypted = new_data["password_encrypted"]
      saved_account.save
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
    account_username = params[:accoaunt_username]
    account = User.where(username: account_username).first
    secrets_owned = account ? User[account.id].secrets : []
    secrets_shared = account ? User[account.id].secrets_shared : []
    secrets_received = account ? User[account.id].secrets_received : []

    if account
      JSON.pretty_generate(data: account, secrets: { owned: secrets_owned , shared: secrets_shared , received: secrets_received})
    else
      halt 404, "ACCOUNT NOT FOUND: #{account_username}"
    end
  end

  get '/api/v1/accounts/:account_username/secrets/:secret_id/?' do
    content_type 'application/json'
    secret_find = nil
    account_username = params[:account_username]
    account = User.where(username: account_username).first

    secrets_owned = account ? User[account.id].secrets : []
    secrets_owned.each do |secret|
      if Integer(secret.id) == Integer(params[:secret_id])
        secret_find = secret
      end
    end

    if !secret_find
      secrets_received = account ? User[account.id].secrets_received : []
      secrets_received.to_a.each do |secret|
        if Integer(secret.id) == Integer(params[:secret_id])
          secret_find = secret
        end
      end
    end

    if secret_find
      JSON.pretty_generate(data: secret_find)
    else
      halt 404, "SECRET NOT FOUND OR YOU ARE NOT AUTHORIZED TO READ: #{account_username}"
    end
  end

  post '/api/v1/accounts/:account_username/secrets/?' do
    begin
      new_data = JSON.parse(request.body.read)
      saved_secret = Secret.new(title: new_data["title"], description: new_data["description"])
      saved_secret.account_encrypted = new_data["account_encrypted"]
      saved_secret.password_encrypted = new_data["password_encrypted"]
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
end
