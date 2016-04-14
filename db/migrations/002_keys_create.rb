require 'sequel'

Sequel.migration do
  change do
    create_table(:keys) do
      primary_key :id
      foreign_key :account_id
      String :title, null: false
      String :description, null: true
      String :key, null: false
      String :value, null: false

      unique [:key]
    end
  end
end
