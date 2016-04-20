require 'sequel'

Sequel.migration do
  change do
    create_table(:secrets) do
      primary_key :id
      foreign_key :user_id
      String :title, null: false
      String :description, null: true
      String :account_encrypted, null: false
      String :password_encrypted, null: true

      set_allowed_columns :title , :description
    end
  end
end
