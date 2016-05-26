# Find shared secrets by a user
class FindSharedSecrets
  def self.call(username: )
    user = User.where(username: username).first
    user.received_secrets
  end
end
