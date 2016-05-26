# Configuration Sharing Web Service
class ShareKeysAPI < Sinatra::Base
  get '/api/v1/users/:owner_id/owned_secrets/?' do
    content_type 'application/json'
    begin
      owner = User[params[:owner_id]]
      JSON.pretty_generate(data: owner.owned_secrets)
    rescue => e
      logger.info "FAILED to find secrets for user #{params[:owner_id]}: #{e}"
      halt 404
    end
  end

  post '/api/v1/users/:id/owned_secrets/?' do
    begin
      secret_data = JSON.parse(request.body.read)
      secret = CreateSecret.call(
        title: secret_data['title'],
        description: secret_data['description'],
        id: params[:id],
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
