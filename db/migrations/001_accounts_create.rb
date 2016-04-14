require 'sequel'

Sequel.migration do
  change do
    create_table(:accounts) do
      primary_key :id
      String :username, unique: true, null: false
      String :password, unique: false, null: false
      String :email, unique: true, null: false
    end
  end
end
