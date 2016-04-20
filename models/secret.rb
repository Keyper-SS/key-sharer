require 'json'
require 'base64'
require 'sequel'

# Holds the key information for each account
class Secret < Sequel::Model
  many_to_one :users

  set_allowed_columns :title , :description

  def to_json(options = {})
    JSON({  type: 'secret',
            id: id,
            data: {
              title: title,
              description: description,
              account_encrypted: account_encrypted,
              password_encrypted: password_encrypted
            }
          },
         options)
  end

end

# TODO: implement a more complex primary key?
# def new_id
#   Base64.urlsafe_encode64(Digest::SHA256.digest(Time.now.to_s))[0..9]
# end
