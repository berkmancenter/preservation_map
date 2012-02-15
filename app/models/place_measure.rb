class PlaceMeasure < ActiveRecord::Base
    belongs_to :place
    belongs_to :measure
    validates :value, :place, :measure, :presence => true

    def to_percent
        min_value = PlaceMeasure.where( :measure_id => measure_id ).minimum(:value)
        max_value = PlaceMeasure.where( :measure_id => measure_id ).maximum(:value)
        return (value - min_value) / (max_value - min_value)
    end
end
