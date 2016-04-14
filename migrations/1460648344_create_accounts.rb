Sequel.migration do
  change do
  	create_table(:accounts)
  		primary_key :id
  		String :username, unique: true, null: false
      String :password, unique: false, null: false
      String :email, unique: true, null: false
      DateTime :created_at, null: false
  	end
  end
end
