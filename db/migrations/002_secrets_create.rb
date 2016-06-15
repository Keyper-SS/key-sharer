require 'sequel'

Sequel.migration do
  change do
    create_table(:secrets) do
      primary_key :id
      foreign_key :owner_id, :base_users
      String :title, null: false
      String :description, null: true
      String :account_encrypted, null: false
      String :password_encrypted, null: true
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
