Sequel.migration do
  change do
    create_table :episodes do
      primary_key :id
      String      :episode
      String      :season
      String      :season_episode
      String      :product_number
      Date        :air_date
      String      :url
      String      :title
      String      :tvr_show_id

      DateTime    :created_at
      DateTime    :updated_at

      foreign_key :show_id, :shows
    end

    create_join_table(:episode_id => :episodes, :user_id => :users)
  end
end
