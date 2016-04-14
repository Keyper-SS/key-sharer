Sequel.migration do
  change do
  	create_table(:accounts)
  		primary_key :id
  		Integer :account_id, null: false
      Integer :key_id,  null: false
      DateTime :created_at, null: false

      unique [:account_id, :key_id]
  	end
  end
end
