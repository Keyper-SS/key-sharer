require 'json'
require 'base64'
require 'sequel'

# Holds the key information for each account
class Sharing < Sequel::Model
  many_to_many :secrets

  def to_json(options = {})
    JSON({  type: 'sharing',
            id: id,
            attributes: {
              sharer_id: sharer_id,
              receiver_id: receiver_id,
              secret_id: secret_id
            }
          },
         options)
  end
end
