module Seeds
  class Users
    def self.clear
    end

    def self.load
      email    = ENV['EMAIL']    || user@test.com
      password = ENV['PASSWORD'] || SecureRandom.hex(16)
      user = User.create(
        :email                 => email,
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
