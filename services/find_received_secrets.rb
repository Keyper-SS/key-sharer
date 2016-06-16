# Find shared secrets by a user
class FindReceivedSecrets
  def self.call(id:)
    user = BaseUser[id]
    user.received_secrets
  end
end
