class CreateUser
	def self.call(username:, email:, password:)
		user =  User.new(username: username,
                            email: email)
    user.password = password
    user.save
	end
end