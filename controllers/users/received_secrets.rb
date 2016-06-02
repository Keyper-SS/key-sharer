class ShareKeysAPI < Sinatra::Base
  get '/api/v1/users/:id/received_secrets/?' do
    content_type 'application/json'
    begin
      id = params[:id]
      halt 401 unless authorized_user?(env, id)
      received_secrets = FindReceivedSecrets.call(id: id)
      received_secrets_with_receiver = received_secrets.map do |s|
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

      JSON.pretty_generate(data: received_secrets_with_receiver)
    rescue => e
      logger.info "FAILED to find received secrest for user: #{e}"
      halt 404
    end
  end
end
