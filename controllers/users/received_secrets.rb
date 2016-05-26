class ShareKeysAPI < Sinatra::Base
  get '/api/v1/users/:id/received_secrets/?' do
    content_type 'application/json'
    begin
      id = params[:id]
      halt 401 unless authorized_user?(env, id)
      puts id
      received_secrets = FindReceivedSecrets.call(id: id)
      JSON.pretty_generate(data: received_secrets)
    rescue => e
      logger.info "FAILED to find received secrest for user: #{e}"
      halt 404
    end
  end
end
