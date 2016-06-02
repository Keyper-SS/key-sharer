class ShareKeysAPI < Sinatra::Base
  post '/api/v1/users/:sharer_id/owned_secrets/:secret_id/share' do
    begin
      sharer_id = params[:sharer_id]
      secret_id = params[:secret_id]

      halt 401 unless authorized_user?(env, sharer_id)
      share_info = JSON.parse(request.body.read)
      receiver_username = share_info['receiver_username']
      receiver = User.where(username: receiver_username).first

      CreateSharing.call(
        sharer_id: sharer_id,
        receiver_id: receiver.id,
        secret_id: secret_id
      )
    rescue => e
      logger.info "FAILED to share secret: #{e.inspect}"
      halt 400
    end
    status 201
  end
end