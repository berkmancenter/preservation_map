class PlaceField < ActiveRecord::Base
    belongs_to :place
    belongs_to :field
    validates :place, :field, :presence => true
end
