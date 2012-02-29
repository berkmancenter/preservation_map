class PlaceMeasure < ActiveRecord::Base
    belongs_to :place
    belongs_to :measure
    validates :place, :measure, :presence => true
end
