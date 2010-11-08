migration 1, :create_shows do
  up do
    create_table :shows do
      column :id, DataMapper::Property::Integer, :serial => true
      
    end
  end

  down do
    drop_table :shows
  end
end
