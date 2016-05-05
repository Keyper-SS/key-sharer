# Configuration Sharing Web Service
class ShareKeysAPI < Sinatra::Base
  get '/api/v1/users/:username/secrets/?' do
    content_type 'application/json'
    username = params[:username]
    user = User.where(username: username).first
    owned_secrets = user ? User[user.id].owned_secrets : []
    shared_secrets = user ? User[user.id].shared_secrets : []
    received_secrets = user ? User[user.id].received_secrets : []

    if user
      JSON.pretty_generate(data: user, secrets: { owned: owned_secrets,
                                                  shared: shared_secrets,
                                                  received: received_secrets })
    else
      halt 404, "ACCOUNT NOT FOUND: #{username}"
    end
  end

  get '/api/v1/users/:username/secrets/:secret_id/?' do
    content_type 'application/json'
    secret_find = nil
    username = params[:username]
    user = User.where(username: username).first

    owned_secrets = user ? User[user.id].owned_secrets : []
    owned_secrets.each do |secret|
      secret_find = secret if Integer(secret.id) == Integer(params[:secret_id])
    end

    if secret_find
      JSON.pretty_generate(data: secret_find)
    else
      halt 404, "SECRET NOT FOUND OR NOT AUTHORIZED TO READ: #{username}"
    end
  end

  post '/api/v1/users/:username/secrets/?' do
    begin
      secret_data = JSON.parse(request.body.read)
      secret = CreateSecret.call(
        title: secret_data['title'],
        description: secret_data['description'],
        username: params[:username],
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
