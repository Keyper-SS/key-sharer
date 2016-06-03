class ShareKeysAPI < Sinatra::Base
  get '/api/v1/users/:receiver_id/received_secrets/?' do
    content_type 'application/json'
    begin
      receiver_id = params[:receiver_id].to_i
      halt 401 unless authorized_user?(env, receiver_id)

      received_secrets = FindReceivedSecrets.call(id: receiver_id)
      received_secrets_with_sharer = received_secrets.map do |s|
        {
          'secret_id' => s.id,
          'sharer_username' => User[s.owner_id].username,
          'sharer_email' => User[s.owner_id].email,
          'data' => {
            'title' => s.title,
            'description' => s.description,
            'account' => s.account,
            'password' => s.password
          }
        }
      end

      JSON.pretty_generate(data: received_secrets_with_sharer)
    rescue => e
      logger.info "FAILED to find received secrest for user: #{e}"
      halt 404
    end
  end

  get '/api/v1/users/:receiver_id/received_secrets/:secret_id' do
    content_type 'application/json'
    begin
      receiver_id = params[:receiver_id]
      halt 401 unless authorized_user?(env, receiver_id)

      secret = Secret[params[:secret_id]]
      secret_info = {
        'secret_id' => secret.id,
        'sharer_username' => User[secret.owner_id].username,
        'sharer_email' => User[secret.owner_id].email,
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
end
