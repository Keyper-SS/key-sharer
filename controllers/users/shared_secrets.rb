class ShareKeysAPI < Sinatra::Base
  get '/api/v1/users/:username/shared_secrets/?' do
    content_type 'application/json'
    username = params[:username]
    user = User.where(username: username).first
    shared_secrets = user ? User[user.id].shared_secrets : []

    if user
      JSON.pretty_generate(data: user, shared_secrets:  shared_secrets)
    else
      halt 404, "ACCOUNT NOT FOUND: #{username}"
    end
  end
end
