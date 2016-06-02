class ShareKeysAPI < Sinatra::Base
  get '/api/v1/users/:id/shared_secrets/?' do
    content_type 'application/json'
    begin
      id = params[:id]
      halt 401 unless authorized_user?(env, id)
      shared_secrets = FindSharedSecrets.call(id: id)
      shared_secrets_with_receiver = shared_secrets.map do |s|
        receiver_id = Sharing.where(sharer_id: id, secret_id: s.id).first.receiver_id
        {
          'secret_id' => s.id,
          'sharer_username' => User[receiver_id].username,
          'sharer_email' => User[receiver_id].email,
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
end
