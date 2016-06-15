require 'sequel'

Sequel.migration do
  change do
    create_table(:base_users) do
      primary_key :id
      String :type
      String :username, null: false
      String :email, null: false, unique: true
      String :password_hash
      String :salt
      DateTime :created_at
      DateTime :updated_at

      unique [:type, :username]
    end
  end
end
