Sequel.migration do
  change do
    create_table :users do
      primary_key :id
      String      :email,            :default => '', :size => 255, :unique => true
      String      :username,         :default => ''
      String      :crypted_password, :default => '', :size => 255
      String      :perishable_token, :default => '', :size => 255, :unique => true
      TrueClass   :activated,        :default => false
      DateTime    :activated_at
      String      :role
      TrueClass   :test_user

      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
