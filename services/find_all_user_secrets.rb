# Find all secrets (owned and contributed to) by an user
class FindAllUserSecrets
  def self.call(id:)
    base_user = BaseUser.first(id: id)
    base_user.shared_secrets + base_user.received_secrets + base_user.owned_secrets
  end
end
