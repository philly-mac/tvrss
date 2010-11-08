migration 2, :create_episodes do
  up do
    create_table :episodes do
      column :id, DataMapper::Property::Integer, :serial => true
      
    end
  end

  down do
    drop_table :episodes
  end
end
