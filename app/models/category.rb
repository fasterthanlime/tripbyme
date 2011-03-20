class Category < ActiveRecord::Base
    has_and_belongs_to_many :venue
    has_and_belongs_to_many :event
end
