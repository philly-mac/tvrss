module Seeds
  class Users
    def self.clear
    end

    def self.load
      password = SecureRandom.hex(16)
      user = User.create(
        :email                 => "philip@ivercore.com",
        :password              => password,
        :password_confirmation => password,
      )

      user.activate!
      role = Role.create(:name => 'super_user')

      user.add_role(role)

      puts "User"
      puts "=========="
      puts "Email:    #{user.email}"
      puts "Password: #{password}"
    end

    def self.reload_data
      clear
      load_data
    end
  end
end
