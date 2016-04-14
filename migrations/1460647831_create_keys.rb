Sequel.migration do
  change do
  	create_table(:keys)
  		primary_key :id
  		Integer :account_id , null: false
  		String :title , null: false
  		String :description , null: true
  		String :share_account , null: false
  		String :share_password , null: false
  		DateTime :created_at, null: false
  	end
  end
end
