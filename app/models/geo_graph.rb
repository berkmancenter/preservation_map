require 'csv'

class GeoGraph < ActiveRecord::Base
    belongs_to :user
    has_many :place_measures, :order => [:place_id, :measure_id]
    has_many :places, :through => :place_measures, :uniq => true, :order => :id
    has_many :measures, :through => :place_measures, :uniq => true, :order => :id
    has_attached_file :import_data
    validates_attachment_content_type :import_data, :content_type => 'text/csv'
    validates_attachment_size :import_data, :in => 1..1.megabyte
    validates :name, :presence => true, :length => { :in => 3..50 }

    def import_from_attachment!
        place_col_names = Code::Application.config.place_column_names

        if places? and measures?
            table.each do |row|
                place = Place.new(
                    :name => row[place_col_names[:name]],
                    :latitude => row[place_col_names[:latitude]],
                    :longitude => row[place_col_names[:longitude]],
                    :api_abbr => row[place_col_names[:api_abbr]]
                )
                places << place
                row.each do |column_name, value|
                    unless place_col_names.value? column_name
                        measure = Measure.find_or_create_by_name_and_geo_graph_id(column_name, id)
                        place_measure = PlaceMeasure.new(:value => value)
                        measure.place_measures << place_measure
                        place.place_measures << place_measure
                        place_measures << place_measure
                    end
                end
            end
        end
    end

    def places?
        return (self.table.headers & Code::Application.config.place_column_names.values).count == Code::Application.config.place_column_names.count
    end

    def measures?
        return self.table.headers.count - (self.table.headers & Code::Application.config.place_column_names.values).count > 0
    end

    def table
        if import_data.exists?
            CSV.read(import_data.path, :headers => true)
        else
            CSV.read(import_data.uploaded_file.tempfile.path, :headers => true)
        end
    end
end
