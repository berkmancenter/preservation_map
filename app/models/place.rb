class Place < ActiveRecord::Base
    has_many :place_measures
    has_many :measures, :through => :place_measures
    belongs_to :data_map

    def size(measure)
        measure.size(self)
    end

    def color(measure, color_theme = nil)
        measure.color(self, color_theme)
    end

    def value(measure)
        measure.value(self)
    end

    def display_value(measure)
        measure.display_value(self)
    end

    def metadata
        return measures.metadata.map { |measure| { :name => measure.name, :data => measure.metadata(self) } }
    end

end
