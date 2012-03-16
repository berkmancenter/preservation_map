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

    # validates_attachment_content_type :import_data, :content_type => 'text/csv'
    validates_attachment_size :import_data, :in => 1..1.megabyte
    validates :name, :length => { :in => 3..50 }
    validates :num_legend_sizes, :num_legend_colors, :numericality => {
        :only_integer => true, :less_than_or_equal_to => 50, :greater_than_or_equal_to => 0
    }
    validates :min_spot_size, :max_spot_size, :numericality => {
        :less_than_or_equal_to => 100, :greater_than_or_equal_to => 0
    }
    validate :min_spot_size_and_max_spot_size_are_not_both_zero
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
                :sizeMeasureValue => place.display_value(size_measure),
                :color => place.color(color_measure, color_theme),
                :colorMeasureValue => place.display_value(color_measure),
                :metadata => place.metadata
            }
        end
        return hash
    end

    def import_data_from_attachment!
        required_col_names = Code::Application.config.place_column_names[:required]
        optional_col_names = Code::Application.config.place_column_names[:optional]

        if places? and measures?
            table.each do |row|
                place_attrs = {
                    :name => row[required_col_names[:name]],
                    :latitude => row[required_col_names[:latitude]],
                    :longitude => row[required_col_names[:longitude]]
                }
                place_attrs[:api_abbr] = row[optional_col_names[:api_abbr]]
                places << Place.new(place_attrs)
            end

            table.headers.each do |header|
                unless required_col_names.value? header or optional_col_names.value? header
                    if is_yes_no_column?(header)
                        attrs = { :datatype => 'yes_no', :reverse_color_theme => true }
                    elsif not is_numeric_column?(header)
                        attrs = { :datatype => 'metadata' }
                    else
                        attrs = { :datatype => 'numeric' }
                    end
                    attrs[:name] = header
                    measures << Measure.new(attrs)
                end
            end

            self.save

            table.each do |row|
                place = places.select{ |place|
                    place.name == row[required_col_names[:name]] and
                    place.latitude == row[required_col_names[:latitude]].to_f and
                    place.longitude == row[required_col_names[:longitude]].to_f
                }.first
                row.each do |column_name, value|
                    unless required_col_names.value? column_name or optional_col_names.value? column_name
                        measure = measures.select{ |measure| measure.name == column_name }.first
                        case measure.datatype
                        when 'metadata'
                            place_measure = PlaceMeasure.new(:metadata => value)
                        when 'yes_no'
                            place_measure = PlaceMeasure.new(:value => yes_no_to_value(value))
                        else
                            place_measure = PlaceMeasure.new(:value => value.to_f)
                        end
                        measure.place_measures << place_measure
                        place.place_measures << place_measure
                    end
                end
            end

            self.color_measure ||= self.measures.numeric.first
            self.size_measure ||= self.measures.numeric.last
        end

        return self
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

    # These need to go into a module
    def yes_no_to_value(s)
        Code::Application.config.yes_no.each { |word, info| info[:possibilities].each { |possible| return info[:value] if s.casecmp(possible) == 0 } }
        return false
    end

    def yes_no_to_word(s)
        Code::Application.config.yes_no.each { |word, info| info[:possibilities].each { |possible| return word if s.casecmp(possible) == 0 } }
        return false
    end

    def value_to_yes_no(f)
        Code::Application.config.yes_no.each { |word, info| return word if info[:value] == f }
        return false
    end

    def has_api_abbrs?
        return !(self.table.headers & [Code::Application.config.place_column_names[:optional][:api_abbr]]).empty?
    end

    def min_spot_size_and_max_spot_size_are_not_both_zero
        if min_spot_size == 0 and max_spot_size == 0
            errors.add(:min_spot_size, %{can't be zero while "Maximum spot size" is zero})
            errors.add(:max_spot_size, %{can't be zero while "Minimum spot size" is zero})
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
        return (self.table.headers & Code::Application.config.place_column_names[:required].values).count == Code::Application.config.place_column_names[:required].count
    end

    def measures?
        return self.table.headers.count - (self.table.headers & Code::Application.config.place_column_names[:required].values).count > 0
    end

    def is_numeric?(i)
        return true if Float(i) rescue false
    end

    def is_numeric_column?(header)
        self.table.values_at(header).each { |value| return false if not is_numeric?(value[0]) }
        return true
    end

    def is_yes_no?(s)
        return yes_no_to_word(s).kind_of? String
    end

    def is_yes_no_column?(header)
        self.table.values_at(header).each { |value| return false if not is_yes_no?(value[0]) }
        return true
    end

    def table
        if import_data.exists?
            CSV.read(import_data.path, :headers => true)
        else
            CSV.read(import_data.uploaded_file.tempfile.path, :headers => true)
        end
    end
end
