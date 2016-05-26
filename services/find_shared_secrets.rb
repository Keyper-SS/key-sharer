# Find shared secrets by a user
class FindSharedSecrets
  def self.call(id: )
    user = User[id]
    user.shared_secrets
  end
end
