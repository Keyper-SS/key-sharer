# Configuration Sharing Web Service
class ShareKeysAPI < Sinatra::Base
  get '/api/v1/users/:username/owned_secrets/?' do
    content_type 'application/json'
    username = params[:username]
    user = User.where(username: username).first
    owned_secrets = user ? User[user.id].owned_secrets : []

    if user
      JSON.pretty_generate(data: user, owned_secrets:  owned_secrets)
    else
      halt 404, "ACCOUNT NOT FOUND: #{username}"
    end
  end

  post '/api/v1/users/:username/owned_secrets/?' do
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