class ShareKeysAPI < Sinatra::Base
  get '/api/v1/users/:sharer_id/shared_secrets/?' do
    content_type 'application/json'
    begin
      sharer_id = params[:sharer_id]
      halt 401 unless authorized_user?(env, sharer_id)

      shared_secrets = FindSharedSecrets.call(id: sharer_id)
      shared_secrets_with_receiver = shared_secrets.map do |s|
        sharing = Sharing.where(sharer_id: sharer_id, secret_id: s.id).first
        receiver = BaseUser[sharing.receiver_id]
        {
          'secret_id' => s.id,
          'sharer_username' => receiver.username,
          'sharer_email' => receiver.email,
          'data' => {
            'title' => s.title,
            'description' => s.description,
            'account' => s.account,
            'password' => s.password
          }
        }
      end
      JSON.pretty_generate(data: shared_secrets_with_receiver)
    rescue => e
      logger.info "FAILED to find shared secrest for user: #{e}"
      halt 404
    end
  end

  get '/api/v1/users/:sharer_id/shared_secrets/:secret_id' do
    content_type 'application/json'
    begin
      sharer_id = params[:sharer_id]
      halt 401 unless authorized_user?(env, sharer_id)

      secret_id = params[:secret_id]
      secret = Secret[secret_id]

      sharing = Sharing.where(sharer_id: sharer_id, secret_id: secret_id).first
      receiver = BaseUser[sharing.receiver_id]
      secret_info = {
        'secret_id' => secret.id,
        'sharer_username' => receiver.username,
        'sharer_email' => receiver.email,
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
