class ShareKeysAPI < Sinatra::Base
  get '/api/v1/users/:username/received_secrets/?' do
    content_type 'application/json'
    username = params[:username]
    user = User.where(username: username).first
    received_secrets = user ? User[user.id].received_secrets : []

    if user
      JSON.pretty_generate(data: user, received_secrets:  received_secrets)
    else
      halt 404, "ACCOUNT NOT FOUND: #{username}"
    end
  end
end
