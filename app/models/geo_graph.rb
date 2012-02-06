class GeoGraph < ActiveRecord::Base
    belongs_to :user
    has_many :places
    validates :name, :presence => true, :length => { :in => 3..50 }
end
