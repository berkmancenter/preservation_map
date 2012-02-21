class PlaceMeasure < ActiveRecord::Base
    belongs_to :place
    belongs_to :measure
    validates :value, :place, :measure, :presence => true
end
