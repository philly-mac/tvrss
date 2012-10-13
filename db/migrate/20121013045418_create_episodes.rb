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

    create_table(:watched_episodes_users) do
      foreign_key :episode_id, :episodes
      foreign_key :user_id,    :users
    end
  end
end
