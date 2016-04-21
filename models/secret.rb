require 'json'
require 'base64'
require 'sequel'

# Holds the key information for each account
class Secret < Sequel::Model
  many_to_one :users

  set_allowed_columns :title , :description

  def account=(account_plaintext)
    @account = account_plaintext
    self.account_encrypted = encrypt(@account)
  end

  def account
    @account ||= decrypt(account_encrypted)
  end

  def password=(password_plaintext)
    @password = password_plaintext
    self.password_encrypted = encrypt(@password)
  end

  def password
    @password ||= decrypt(password_encrypted)
  end

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
