# Service object to create new Secret using all columns
class CreateSecret
  def self.call(title:, description:, username:, account:, password:)
    secret = Secret.new(
      title: title,
      description: description)
    user = User.where(username: username).first
    secret.account = account
    secret.password = password
    user.add_owned_secret(secret)
  end
end