# Configuration Sharing Web Service
class ShareKeysAPI < Sinatra::Base
  get '/api/v1/users/:id' do
    content_type 'application/json'

    id = params[:id]
    halt 401 unless authorized_user?(env, id)
    user = BaseUser.where(id: id).first
    if user
      JSON.pretty_generate(data: user, relationships: user.owned_secrets)
    else
      halt 404, "USER NOT FOUND: #{id}"
    end
  end

  post '/api/v1/users/?' do
    begin
      user_data = request.body.read
      saved_user = CreateUser.call(user_data)
    rescue ClientNotAuthorized => e
      halt 401, e.to_s
    rescue => e
      logger.info "FAILED to create new user: #{e.inspect}"
      halt 400
    end

    status 201
    saved_user.to_json
  end
end
