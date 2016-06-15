require 'sequel'

Sequel.migration do
  change do
    create_table(:sharings) do
      primary_key :id
      foreign_key :sharer_id, :base_users
      foreign_key :receiver_id, :base_users
      foreign_key :secret_id, :secrets
      unique [:sharer_id, :receiver_id, :secret_id]
    end
  end
end
