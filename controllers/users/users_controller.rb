# Configuration Sharing Web Service
class ShareKeysAPI < Sinatra::Base
  get '/api/v1/users/:id' do
    content_type 'application/json'

    id = params[:id]
    puts 'env:'
    puts env
    puts 'id'
    puts id
    puts 'start athorized'
    halt 401 unless authorized_user?(env, id)
    puts 'finish authorized'
    user = User.where(id: id).first
    puts user
    if user
      JSON.pretty_generate(data: user, relationships: user.owned_secrets)
    else
      halt 404, "USER NOT FOUND: #{id}"
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
