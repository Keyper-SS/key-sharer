require 'json'
require 'base64'
require 'sequel'

# Holds the key information for each account
class Secret < Sequel::Model
  include SecureModel

  many_to_one :owner, class: :Account

  set_allowed_columns :title , :description

  def account=(acc_plaintext)
    self.account_encrypted = encrypt(acc_plaintext) if acc_plaintext
  end

  def account
    decrypt(account_encrypted)
  end

  def password=(pw_plaintext)
    self.password_encrypted = encrypt(pw_plaintext) if pw_plaintext
  end

  def password
    decrypt(password_encrypted)
  end

  def to_json(options = {})
    JSON({  type: 'secret',
            id: id,
            data: {
              title: title,
              description: description,
              account_encrypted: account,
              password_encrypted: password
            }
          },
         options)
  end

end
