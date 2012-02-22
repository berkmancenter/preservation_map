require 'csv'
require 'json'

class GeoGraph < ActiveRecord::Base
    belongs_to :user
    belongs_to :size_measure, :class_name => 'Measure'
    belongs_to :color_measure, :class_name => 'Measure'
    belongs_to :color_theme

    has_many :places
    has_many :measures
    has_and_belongs_to_many :external_data_sources
    has_attached_file :import_data

    validates_attachment_content_type :import_data, :content_type => 'text/csv'
    validates_attachment_size :import_data, :in => 1..1.megabyte
    validates :name, :presence => true, :length => { :in => 3..50 }
    validates :import_data, :min_spot_size, :max_spot_size, :num_legend_sizes, :num_legend_colors, :presence => true
    validates :num_legend_sizes, :num_legend_colors, :numericality => { :only_integer => true, :less_than_or_equal_to => 50, :greater_than_or_equal_to => 0 }
    validates :min_spot_size, :max_spot_size, :numericality => { :less_than_or_equal_to => 100, :greater_than_or_equal_to => 0 }

    after_initialize :add_defaults

    def as_json(options={})
        Measure.includes(:place_measures)
        hash = {
            :name => name,
            :color_theme => { :gradient => color_theme.gradient },
            :legend_sizes => size_measure.legend_sizes,
            :legend_colors => color_measure.legend_colors(color_theme),
            :min_spot_size => min_spot_size,
            :max_spot_size => max_spot_size
        }
        hash[:places] = places.map do |place| 
            {
                :name => place.name,
                :latitude => place.latitude,
                :longitude => place.longitude,
                :size => place.size(size_measure),
                :sizeMeasureValue => place.value(size_measure),
                :color => place.color(color_measure, color_theme),
                :colorMeasureValue => place.value(color_measure)
            }
        end
        return hash
    end

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

    def all_measures
        unless external_data_sources.empty?
            measures + external_data_sources.map { |source| source.measures }.flatten!
        else
            measures
        end
    end

    protected
    def add_defaults
        self.color_theme ||= ColorTheme.first
        self.max_spot_size ||= 20 
        self.min_spot_size ||= 5
        self.num_legend_sizes ||= 5
        self.num_legend_colors ||= 5
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
