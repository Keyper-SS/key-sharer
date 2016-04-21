require 'json'
require 'base64'
require 'sequel'

# Holds a User information
class User < Sequel::Model
  include EncryptableModel

  one_to_many :secrets
  many_to_many :secrets_received, :class=> :Secret , :left_key=>:receiver_id, :right_key=>:secret_id, :join_table=>:sharings
  many_to_many :secrets_shared, :class=> :Secret ,:left_key=>:sharer_id, :right_key=>:secret_id, :join_table=>:sharings

  set_allowed_columns :username, :email

  def password=(password_plaintext)
    @password = password_plaintext
    self.password_encrypted = encrypt(@password)
  end

  def password
    @password ||= decrypt(password_encrypted)
  end

  def to_json(options = {})
    JSON({  type: 'user',
            id: id,
            attributes: {
              username: username,
              password: password_encrypted,
              email: email
            }
          },
         options)
  end
end
