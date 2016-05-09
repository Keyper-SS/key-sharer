# Service object to create new user using all columns
class CreateSharing
  def self.call(sharer_id:, receiver_id:, secret_id:)
    sharing = Sharing.new(
      sharer_id: sharer_id,
      receiver_id: receiver_id,
      secret_id: secret_id
    )
    sharing.save
  end
end
