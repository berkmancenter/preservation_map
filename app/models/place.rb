class Place < ActiveRecord::Base
    has_many :place_fields
    has_many :fields, :through => :place_fields
    belongs_to :data_map

    attr_accessible :name, :latitude, :longitude, :api_abbr

    def size(field)
        field.size(self)
    end

    def color(field, color_theme = nil)
        field.color(self, color_theme)
    end

    def value(field)
        field.value(self)
    end

    def datum(field)
        place_fields.find_by_field_id(field)
    end

    def display_value(field)
        field.display_value(self)
    end

    def metadata
        return fields.metadata.map { |field| { :name => field.name, :data => field.metadata(self) } }
    end

end
