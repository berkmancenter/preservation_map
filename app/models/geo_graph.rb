require 'csv'
require 'json'

class GeoGraph < ActiveRecord::Base
    belongs_to :user

    has_many :places
    has_many :measures
    has_and_belongs_to_many :external_data_sources
    has_attached_file :import_data

    validates_attachment_content_type :import_data, :content_type => 'text/csv'
    validates_attachment_size :import_data, :in => 1..1.megabyte
    validates :name, :presence => true, :length => { :in => 3..50 }

    serialize :color_theme

    before_save :add_defaults

    def import_from_attachment!
        place_col_names = Code::Application.config.place_column_names

        if places? and measures?
            table.each do |row|
                places << Place.new(
                    :name => row[place_col_names[:name]],
                    :latitude => row[place_col_names[:latitude]],
                    :longitude => row[place_col_names[:longitude]],
                    :api_abbr => row[place_col_names[:api_abbr]]
                )
            end


            table.headers.each do |header|
                unless place_col_names.value? header
                    measures << Measure.new(:name => header)
                end
            end

            self.save

            table.each do |row|
                place = places.find_by_api_abbr(row[place_col_names[:api_abbr]])
                row.each do |column_name, value|
                    unless place_col_names.value? column_name
                        measure = measures.find_by_name(column_name)
                        place_measure = PlaceMeasure.new(:value => value.to_f)
                        measure.place_measures << place_measure
                        place.place_measures << place_measure
                    end
                end
            end

            self.color_measure_id ||= self.measures[3].id
            self.size_measure_id ||= self.measures[3].id
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

    def all_measures
        unless external_data_sources.empty?
            measures + external_data_sources.map { |source| source.measures }.flatten!
        else
            measures
        end
    end

    def to_json(arg = nil)
        return_object = [];

        places.each do |place|
            return_object << {
                :name => place.name,
                :latitude => place.latitude,
                :longitude => place.longitude,
                :size => Measure.find(size_measure_id).size(place),
                :color => Measure.find(color_measure_id).color(place),
                :colorMeasureValue => Measure.find(color_measure_id).value(place),
                :sizeMeasureValue => Measure.find(size_measure_id).value(place)
            }
        end

        return return_object.to_json
    end

    protected
    def add_defaults
        self.color_theme ||= {
            0 => '#0000b0',
            25 => '#00e3eb',
            50 => '#00d100',
            75 => '#ffff00',
            100 => '#e80202'
        }
        self.max_spot_size ||= 20 
        self.min_spot_size ||= 3
    end
end
