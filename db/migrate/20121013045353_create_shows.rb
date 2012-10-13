Sequel.migration do
  change do
    create_table :shows do
      primary_key :id
      String      :tvr_show_id,   :null => false, :unique => true
      String      :name
      String      :url,           :text    => true
      String      :show_status
      String      :genres
      String      :search_as
      Boolean     :independent, :default  => false
      DateTime    :created_at
      DateTime    :updated_at
    end

    create_join_table(:show_id => :shows, :user_id => :users)

  end
end
