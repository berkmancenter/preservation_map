require 'csv'
require 'json'

class GeoGraph < ActiveRecord::Base
    belongs_to :user
    belongs_to :size_measure, :class_name => 'Measure'
    belongs_to :color_measure, :class_name => 'Measure'
    belongs_to :color_theme

    has_many :places
    has_many :measures, :order => :name
    has_and_belongs_to_many :external_data_sources
    has_attached_file :import_data

    validates :name,
              :import_data,
              :min_spot_size,
              :max_spot_size,
              :num_legend_sizes,
              :num_legend_colors, 
    :presence => true

    validates_attachment_content_type :import_data, :content_type => 'text/csv'
    validates_attachment_size :import_data, :in => 1..1.megabyte
    validates :name, :length => { :in => 3..50 }
    validates :num_legend_sizes, :num_legend_colors, :numericality => {
        :only_integer => true, :less_than_or_equal_to => 50, :greater_than_or_equal_to => 0
    }
    validates :min_spot_size, :max_spot_size, :numericality => {
        :less_than_or_equal_to => 100, :greater_than_or_equal_to => 0
    }
    accepts_nested_attributes_for :measures

    after_initialize :add_defaults

    def as_json(options={})
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
                :metadata => place.metadata
            }
        end
        return hash
    end

    def import_data_from_attachment!
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
                    if not is_numeric_column?(header)
                        measures << Measure.new(:name => header, :is_metadata => true)
                    else
                        measures << Measure.new(:name => header)
                    end
                end
            end

            self.save

            table.each do |row|
                place = places.find_by_api_abbr(row[place_col_names[:api_abbr]])
                row.each do |column_name, value|
                    unless place_col_names.value? column_name
                        measure = measures.find_by_name(column_name)
                        if measure.is_metadata
                            place_measure = PlaceMeasure.new(:metadata => value)
                        else
                            place_measure = PlaceMeasure.new(:value => value.to_f)
                        end
                        measure.place_measures << place_measure
                        place.place_measures << place_measure
                    end
                end
            end

            self.color_measure_id ||= self.measures.numeric.first.id
            self.size_measure_id ||= self.measures.numeric.last.id
        end
    end

    def import_data_from_external_sources!
        external_data_sources.each do |eds|
            eds.measures.each do |measure|
                measures << measure
            end
        end

        self.save

        external_data_sources.each do |eds|
            places.each do |place|
                measures.where(:external_data_source_id => eds.id).each do |measure|
                    place_measure = PlaceMeasure.new(:value => measure.value(place))
                    place.place_measures << place_measure
                    measure.place_measures << place_measure
                end
            end
        end
    end

    protected
    def add_defaults
        self.color_theme ||= ColorTheme.first
        self.max_spot_size ||= 20 
        self.min_spot_size ||= 5
        self.num_legend_sizes ||= 5
        self.num_legend_colors ||= 5
        self.num_zoom_levels ||= 20
    end

    def places?
        return (self.table.headers & Code::Application.config.place_column_names.values).count == Code::Application.config.place_column_names.count
    end

    def measures?
        return self.table.headers.count - (self.table.headers & Code::Application.config.place_column_names.values).count > 0
    end

    def is_numeric_column?(header)
        self.table.values_at(header).each { |value| logger.debug(value.to_s)
            return false if not is_numeric?(value[0]) }
        return true
    end

    def is_numeric?(i)
        return true if Float(i) rescue false
    end

    def table
        if import_data.exists?
            CSV.read(import_data.path, :headers => true)
        else
            CSV.read(import_data.uploaded_file.tempfile.path, :headers => true)
        end
    end
end
