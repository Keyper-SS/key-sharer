require 'json'
require 'sequel'

# Holds a Account information
class Account < Sequel::Model
  one_to_many :secrets
  has_many :keys, :through => :sharings

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
