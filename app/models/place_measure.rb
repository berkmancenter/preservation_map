class PlaceMeasure < ActiveRecord::Base
    belongs_to :place
    belongs_to :measure
    belongs_to :geo_graph
end
