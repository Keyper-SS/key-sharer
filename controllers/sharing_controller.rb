class ShareKeysAPI < Sinatra::Base
  post '/api/v1/users/:sharer_id/owned_secrets/:secret_id/share' do
    begin
      sharer_id = params[:sharer_id]
      secret_id = params[:secret_id]

      halt 401 unless authorized_user?(env, sharer_id)
      share_info = JSON.parse(request.body.read)
      receiver_email = share_info['receiver_email']
      receiver = BaseUser.where(email: receiver_email).first

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

  delete '/api/v1/users/:sharer_id/owned_secrets/:secret_id/share' do
    begin
      sharer_id = params[:sharer_id]
      secret_id = params[:secret_id]

      halt 401 unless authorized_user?(env, sharer_id)
      delete_info = JSON.parse(request.body.read)
      receiver_id = delete_info['']
      sharing = Sharing.where(sharer_id: sharer_id,
                              receiver_id: receiver_id,
                              secret_id: secret_id).first
      DeleteSharingcall.call(
        sharer_id: sharing.id
      )
    rescue => e
      logger.info "FAILED to share secret: #{e.inspect}"
      halt 400
    end
    status 201
  end
end
