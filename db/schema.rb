Sequel.migration do
  change do
    create_table(:roles) do
      primary_key :id
      column :name, "text"
      column :created_at, "timestamp without time zone"
      column :updated_at, "timestamp without time zone"
    end

    create_table(:schema_migrations) do
      column :filename, "text", :null=>false

      primary_key [:filename]
    end

    self[:schema_migrations].insert(:filename => "20121013045314_create_users.rb")
    self[:schema_migrations].insert(:filename => "20121013045353_create_shows.rb")
    self[:schema_migrations].insert(:filename => "20121013045418_create_episodes.rb")
    self[:schema_migrations].insert(:filename => "20121013051338_create_roles.rb")

    create_table(:shows) do
      primary_key :id
      column :tvr_show_id, "text", :null=>false
      column :name, "text"
      column :url, "text"
      column :show_status, "text"
      column :genres, "text"
      column :search_as, "text"
      column :independent, "boolean", :default=>false
      column :created_at, "timestamp without time zone"
      column :updated_at, "timestamp without time zone"

      index [:tvr_show_id], :name=>:shows_tvr_show_id_key, :unique=>true
    end

    create_table(:users) do
      primary_key :id
      column :email, "character varying(255)", :default=>""
      column :username, "text", :default=>""
      column :crypted_password, "character varying(255)", :default=>""
      column :perishable_token, "character varying(255)", :default=>""
      column :activated, "boolean", :default=>false
      column :activated_at, "timestamp without time zone"
      column :role, "text"
      column :test_user, "boolean"
      column :created_at, "timestamp without time zone"
      column :updated_at, "timestamp without time zone"

      index [:email], :name=>:users_email_key, :unique=>true
      index [:perishable_token], :name=>:users_perishable_token_key, :unique=>true
    end

    create_table(:episodes) do
      primary_key :id
      column :episode, "text"
      column :season, "text"
      column :season_episode, "text"
      column :product_number, "text"
      column :air_date, "date"
      column :url, "text"
      column :title, "text"
      column :tvr_show_id, "text"
      column :created_at, "timestamp without time zone"
      column :updated_at, "timestamp without time zone"
      foreign_key :show_id, :shows, :key=>[:id]
    end

    create_table(:roles_users) do
      foreign_key :role_id, :roles, :null=>false, :key=>[:id]
      foreign_key :user_id, :users, :null=>false, :key=>[:id]

      primary_key [:role_id, :user_id]

      index [:user_id, :role_id]
    end

    create_table(:shows_users) do
      foreign_key :show_id, :shows, :null=>false, :key=>[:id]
      foreign_key :user_id, :users, :null=>false, :key=>[:id]

      primary_key [:show_id, :user_id]

      index [:user_id, :show_id]
    end

    create_table(:watched_episodes_users) do
      foreign_key :episode_id, :episodes, :key=>[:id]
      foreign_key :user_id, :users, :key=>[:id]
    end
  end
end

