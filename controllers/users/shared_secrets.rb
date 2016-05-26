class ShareKeysAPI < Sinatra::Base
  get '/api/v1/users/:id/shared_secrets/?' do
    content_type 'application/json'
    begin
      id = params[:id]
      halt 401 unless authorized_user?(env, id)
      shared_secrets = FindSharedSecrets.call(id: id)
      JSON.pretty_generate(data: shared_secrets)
    rescue => e
      logger.info "FAILED to find shared secrest for user: #{e}"
      halt 404
    end
  end
end
