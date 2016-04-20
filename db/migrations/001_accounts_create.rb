require 'sequel'

Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      String :username, unique: true, null: false
      String :password_encrypted, unique: false, null: false
      String :email, unique: true, null: false

      set_allowed_columns :email
    end
  end
end
