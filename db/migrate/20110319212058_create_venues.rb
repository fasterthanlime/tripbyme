class CreateVenues < ActiveRecord::Migration
  def self.up
    create_table :venues do |t|
      t.string :name
      t.float :lat
      t.float :lng
      t.string :foursquare_id
      t.string :eventful_id

      t.timestamps
    end
  end

  def self.down
    drop_table :venues
  end
end