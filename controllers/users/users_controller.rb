# Configuration Sharing Web Service
class ShareKeysAPI < Sinatra::Base
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
end
