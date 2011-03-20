class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.float :lat
      t.float :lng
      t.string :foursquare_id
      t.string :eventful_id
      t.datetime :start_time
      t.datetime :stop_time
      t.string :category
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
