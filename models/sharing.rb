require 'json'
require 'base64'
require 'sequel'

# Holds the key information for each account
class Sharing < Sequel::Model
  many_to_one :secrets

  # def to_json(options = {})
  #   JSON({  type: 'sharing',
  #           id: id,
  #           data: {
  #             title: title,
  #             description: description,
  #             share_account: share_account,
  #             share_password: share_password
  #           }
  #         },
  #        options)
  # end

end
