require 'sequel'

Sequel.migration do
  change do
    create_table(:sharings) do
      primary_key :id
      foreign_key :shared_by, :accounts
      foreign_key :received_by, :accounts
      Integer :key_id

      unique[:shared_by,:received_by]
    end
  end
end