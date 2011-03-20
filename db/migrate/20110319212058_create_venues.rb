class CreateVenues < ActiveRecord::Migration
  def self.up
    create_table :venues do |t|
      t.string :name
      t.float :lat
      t.float :lng
      t.string :foursquare_id
      t.string :eventful_id
      t.string :gowalla_id
      t.string :places_id
      t.string :brightkite_id
      t.string :description
      t.integer :checkins_count
      t.string :origin

      t.timestamps
    end
  end

  def self.down
    drop_table :venues
  end
end
