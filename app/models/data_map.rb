require 'csv'
require 'json'

class DataMap < ActiveRecord::Base
    belongs_to :user
    belongs_to :size_field, :class_name => 'Field'
    belongs_to :color_field, :class_name => 'Field'
    belongs_to :color_theme

    has_many :places
    has_many :fields, :order => :name
    has_and_belongs_to_many :external_data_sources
    has_attached_file :import_data

    validates :name,
              :import_data,
              :min_spot_size,
              :max_spot_size,
              :num_legend_sizes,
              :num_legend_colors, 
    :presence => true

    validates_attachment_size :import_data, :in => 1..1.megabyte
    validates :name, :length => { :in => 3..50 }
    validates :num_legend_sizes, :num_legend_colors, :numericality => {
        :only_integer => true, :less_than_or_equal_to => 50, :greater_than_or_equal_to => 0
    }
    validates :min_spot_size, :max_spot_size, :numericality => {
        :less_than_or_equal_to => 100, :greater_than_or_equal_to => 0
    }
    validate :min_spot_size_and_max_spot_size_are_not_both_zero

    scope :with_external_data, :conditions => 'id in (SELECT DISTINCT data_map_id FROM data_maps_external_data_sources)'
    accepts_nested_attributes_for :fields

    after_initialize :add_defaults

    def as_json(options={})
        hash = {
            :name => name,
            :color_theme => { :gradient => color_theme.gradient },
            :legend_sizes => size_field.legend_sizes,
            :legend_colors => color_field.legend_colors(color_theme),
            :min_spot_size => min_spot_size,
            :max_spot_size => max_spot_size
        }
        hash[:places] = places.map do |place| 
            {
                :name => place.name,
                :latitude => place.latitude,
                :longitude => place.longitude,
                :size => place.size(size_field),
                :sizeFieldValue => place.display_value(size_field),
                :color => place.color(color_field, color_theme),
                :colorFieldValue => place.display_value(color_field),
                :metadata => place.metadata
            }
        end
        return hash
    end

    def import_data_from_attachment!
        required_col_names = Code::Application.config.place_column_names[:required]
        optional_col_names = Code::Application.config.place_column_names[:optional]

        if places? and fields?
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
                    fields << Field.new(attrs)
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
                        field = fields.select{ |field| field.name == column_name }.first
                        case field.datatype
                        when 'metadata'
                            place_field = PlaceField.new(:metadata => value)
                        when 'yes_no'
                            place_field = PlaceField.new(:value => yes_no_to_value(value))
                        else
                            place_field = PlaceField.new(:value => value.to_f)
                        end
                        field.place_fields << place_field
                        place.place_fields << place_field
                    end
                end
            end

            self.color_field ||= self.fields.numeric.first
            self.size_field ||= self.fields.numeric.last
        end

        return self
    end

    def retrieve_external_data!
        external_data_sources.each do |eds|
            eds.fields.each do |field|
                fields.where(:name => field.name, :external_data_source_id => field.external_data_source_id).first_or_create(
                    field.attributes.keep_if do |key, v|
                        ['name', 'api_url', 'datatype', 'log_scale', 'reverse_color_theme', 'external_data_source_id'].include? key
                    end
                )
            end
        end

        self.save

        fields.from_external_source.each do |field|
            places.each do |place|
                place_field = PlaceField.where(:place_id => place.id, :field_id => field.id).first_or_initialize
                begin
                    place_field.value = field.external_data_source.value(place, field)
                    rescue
                        if place_field.new_record?
                            logger.error("Failed on new record - setting value to 0.0")
                            place_field.value = 0.0
                        end
                end
                unless place_field.changed?
                    place_field.touch
                end
                place_field.save
                sleep(0.2)
            end
        end
    end
    handle_asynchronously :retrieve_external_data!

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

    def fields?
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
