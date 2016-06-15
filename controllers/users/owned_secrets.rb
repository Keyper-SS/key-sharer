# Configuration Sharing Web Service
class ShareKeysAPI < Sinatra::Base
  get '/api/v1/users/:owner_id/owned_secrets/?' do
    content_type 'application/json'
    begin
      owner_id = params[:owner_id]
      halt 401 unless authorized_user?(env, owner_id)

      owner = User[owner_id]
      owned_secrets = owner.owned_secrets.map do |s|
        {
          'secret_id' => s.id,
          'data' => {
            'title' => s.title,
            'description' => s.description,
            'account' => s.account,
            'password' => s.password
          }
        }
      end

      JSON.pretty_generate(data: owned_secrets)
    rescue => e
      logger.info "FAILED to find secrets for user #{params[:owner_id]}: #{e}"
      halt 404
    end
  end

  get '/api/v1/users/:owner_id/owned_secrets/:secret_id' do
    content_type 'application/json'
    begin
      owner_id = params[:owner_id]
      halt 401 unless authorized_user?(env, owner_id)


      secret = Secret[params[:secret_id]]
      secret_info = {
        'secret_id' => secret.id,
        'data' => {
          'title' => secret.title,
          'description' => secret.description,
          'account' => secret.account,
          'password' => secret.password
        }
      }
      JSON.pretty_generate(data: secret_info)
    rescue => e
      logger.info "FAILED to find secrets for user #{params[:owner_id]}: #{e}"
      halt 404
    end
  end

  post '/api/v1/users/:owner_id/owned_secrets/?' do
    begin
      owner_id = params[:owner_id]
      halt 401 unless authorized_user?(env, owner_id)

      secret_data = JSON.parse(request.body.read)
      secret = CreateSecret.call(
        title: secret_data['title'],
        description: secret_data['description'],
        owner_id: owner_id,
        account: secret_data['account'],
        password: secret_data['password'])
    rescue => e
      logger.info "FAILED to create new secret: #{e.inspect}"
      halt 400
    end

    status 201
    secret.to_json
  end
end
