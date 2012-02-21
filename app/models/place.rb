class Place < ActiveRecord::Base
    has_many :place_measures
    has_many :measures, :through => :place_measures
    belongs_to :geo_graph

    validates :api_abbr, :presence => true

    def size(measure)
        measure.size(self)
    end

    def color(measure, color_theme = nil)
        measure.color(self, color_theme)
    end

    def value(measure)
        measure.value(self)
    end
end
