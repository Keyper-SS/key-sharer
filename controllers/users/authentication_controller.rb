# Sinatra Application Controllers
class ShareKeysAPI < Sinatra::Base
  post '/api/v1/users/authenticate' do
    content_type 'application/json'

    credentials = JSON.parse(request.body.read)
    user = FindAndAuthenticateUser.call(
      username: credentials['username'],
      password: credentials['password'])

    if user
      user.to_json
    else
      halt 401, 'User could not be authenticated'
    end
  end
end
