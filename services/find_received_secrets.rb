# Find shared secrets by a user
class FindReceivedSecrets
  def self.call(id:)
    user = User[id]
    user.received_secrets
  end
end
