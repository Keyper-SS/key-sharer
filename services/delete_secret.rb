# Service object to create new Secret using all columns
class DeleteSecret
  def self.call(secret_id:)
    secret = Secret[secret_id]

    sharing_relationship = Sharing.where(secret_id: secret_id).all
    sharing_relationship.each do |sharing|
      DeleteSharing.call(sharing_id: sharing.id)
    end

    secret.delete
  end
end
