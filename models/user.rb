require 'sequel'
require 'rbnacl/libsodium'
require 'base64'
require 'json'

# Holds a User information
class BaseUser < Sequel::Model
  plugin :single_table_inheritance, :type
  plugin :timestamps, update_on_create: true

  one_to_many :owned_secrets,
              class: :Secret,
              key: :owner_id
  many_to_many :received_secrets,
               class: :Secret,
               left_key: :receiver_id, right_key: :secret_id,
               join_table: :sharings
  many_to_many :shared_secrets,
               class: :Secret,
               left_key: :sharer_id, right_key: :secret_id,
               join_table: :sharings

  set_allowed_columns :username, :email

  plugin :association_dependencies, owned_secrets: :destroy

  def to_json(options = {})
    JSON({  type: type,
            id: id,
            attributes: {
              username: username,
              email: email
            }
          },
         options)
  end
end

# Regular User with full credentials
class User < BaseUser
  def password=(new_password)
    new_salt = SecureDB.new_salt
    hashed = SecureDB.hash_password(new_salt, new_password)
    self.salt = new_salt
    self.password_hash = hashed
  end

  def password?(try_password)
    try_hashed = SecureDB.hash_password(salt, try_password)
    try_hashed == password_hash
  end
end

# SSO User without passwords
class SsoUser < BaseUser
end
