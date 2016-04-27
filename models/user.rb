require 'sequel'
require 'rbnacl/libsodium'
require 'base64'
require 'json'

# Holds a User information
class User < Sequel::Model
  include SecureModel

  one_to_many :secrets

  many_to_many :secrets_received,
               class: :Secret,
               left_key: :receiver_id, right_key: :secret_id,
               join_table: :sharings

  many_to_many :secrets_shared,
               class: :Secret,
               left_key: :sharer_id, right_key: :secret_id,
               join_table: :sharings

  set_allowed_columns :username, :email

  def password=(new_password)
    nacl = RbNaCl::Random.random_bytes(RbNaCl::PasswordHash::SCrypt::SALTBYTES)
    digest = hash_password(nacl, new_password)
    self.salt = Base64.urlsafe_encode64(nacl)
    self.password_hash = Base64.urlsafe_encode64(digest)
  end

  def password?(try_password)
    nacl = Base64.urlsafe_decode64(salt)
    try_digest = hash_password(nacl, try_password)
    try_password_hash = Base64.urlsafe_encode64(try_digest)
    try_password_hash == password_hash
  end

  def to_json(options = {})
    JSON({  type: 'user',
            id: id,
            attributes: {
              username: username
            }
          },
         options)
  end
end
