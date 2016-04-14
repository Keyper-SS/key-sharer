require 'json'
require 'sequel'

# Holds a Account information
class Account < Sequel::Model
  one_to_many :key

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
