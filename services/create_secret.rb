# Service object to create new Secret using all columns
class CreateSecret
  def self.call(title:, description:, owner_id:, account:, password:)
    secret = Secret.new(
      title: title,
      description: description)
    user = BaseUser[owner_id]
    secret.account = account
    secret.password = password
    user.add_owned_secret(secret)
  end
end
