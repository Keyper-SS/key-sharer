require 'json'
require 'sequel'

# Holds a Account information
class Account < Sequel::Model
  one_to_many :secrets
  many_to_many :secrets_received, :class=> :Secret , :left_key=>:receiver_id, :right_key=>:secret_id, :join_table=>:sharings
  many_to_many :secrets_shared, :class=> :Secret ,:left_key=>:sharer_id, :right_key=>:secret_id, :join_table=>:sharings

  def to_json(options = {})
    JSON({  type: 'account',
            id: id,
            attributes: {
              username: username,
              password: password,
              email: email
            }
          },
         options)
  end
end
