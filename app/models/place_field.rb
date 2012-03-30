class PlaceField < ActiveRecord::Base
    belongs_to :place
    belongs_to :field
    attr_accessible :value, :metadata
    validates :place, :field, :presence => true
end
