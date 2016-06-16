# Find shared secrets by a user
class FindSharedSecrets
  def self.call(id: )
    user = BaseUser[id]
    user.shared_secrets
  end
end
