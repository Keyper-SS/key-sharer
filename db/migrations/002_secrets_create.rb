require 'sequel'

Sequel.migration do
  change do
    create_table(:secrets) do
      primary_key :id
      foreign_key :account_id
      String :title, null: false
      String :description, null: true
      String :share_account, null: false
      String :share_password, null: true
    end
  end
end
