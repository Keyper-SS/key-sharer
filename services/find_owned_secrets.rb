# Find owned secrets by a user
class FindOwnedSecrets
  def self.call(username: )
    user = User.where(username: username).first
    user.owned_secrets
  end
end
