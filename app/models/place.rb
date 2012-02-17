class Place < ActiveRecord::Base
    has_many :place_measures
    has_many :measures, :through => :place_measures
    belongs_to :geo_graph

    validates :api_abbr, :presence => true

    acts_as_api

    api_accessible :processed_data do |template|
        template.add :name
        template.add :latitude
        template.add :longitude
        template.add lambda{ |place|
            place.geo_graph.size_measure.size(place.id)
        }, :as => :size
        template.add lambda{ |place|
            place.geo_graph.size_measure.value(place.id)
        }, :as => :sizeMeasureValue
        template.add lambda{ |place|
            place.geo_graph.color_measure.color(place.id)
        }, :as => :color
        template.add lambda{ |place|
            place.geo_graph.color_measure.value(place.id)
        }, :as => :colorMeasureValue
    end
end
