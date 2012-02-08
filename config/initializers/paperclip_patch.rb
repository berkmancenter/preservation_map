require 'csv'

Paperclip::Attachment.class_eval do
    def place_column_names
        ['Place Name', 'Latitude', 'Longitude', 'API Code']
    end

    def places?
        return (self.table.headers & place_column_names).count == place_column_names.count
    end

    def places
        Array.new(self.table.count) do |i|
            Place.new(
                :name => self.table[i].field('Place Name'),
                :latitude => self.table[i].field('Latitude'),
                :longitude => self.table[i].field('Longitude'),
                :api_abbr => self.table[i].field('API Code')
            )
        end
    end

    def measures
        if self.places?
            return self.table.by_col!.delete_if { |name, col| place_column_names.include? name }.by_row!
        else
            self.table
        end
    end

    def table
        unless path
        end
        CSV.read(path, :headers => true)
    end
end
