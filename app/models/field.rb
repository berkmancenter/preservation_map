class Field < ActiveRecord::Base
    has_many :place_fields
    has_many :places, :through => :place_fields
    belongs_to :data_map
    belongs_to :external_data_source
    attr_accessible :name, :api_url, :external_data_source_id, :log_scale, :reverse_color_theme, :datatype, :external_data_source
    scope :numeric, where(:datatype => 'numeric')
    scope :metadata, where(:datatype => 'metadata')
    scope :yes_no, where(:datatype => 'yes_no')
    scope :selectable, where("datatype IN ('numeric', 'yes_no') AND (SELECT (SELECT COUNT(*) FROM place_fields WHERE field_id = fields.id) = (SELECT COUNT(*) FROM places WHERE data_map_id = fields.data_map_id))") 
    scope :from_external_source, where('external_data_source_id IS NOT NULL')

    def size(place)
        percent = value_to_percent(value(place))
        return percent_to_size(percent)
    end

    def color(place, color_theme = nil)
        percent = value_to_percent(value(place))
        return percent_to_color(percent, color_theme)
    end

    def value(place)
        return place_fields.find_by_place_id(place.id).value
    end

    def display_value(place)
        value = value(place)
        value = data_map.value_to_yes_no(value) if datatype == 'yes_no'
        return value
    end

    def metadata(place)
        return place_fields.find_by_place_id(place.id).metadata
    end

    def legend_sizes
        sizes = []
        num_legend_sizes = [data_map.num_legend_sizes, num_unique_values].min
        num_legend_sizes.times do |i|
            if num_legend_sizes == 1 
                percent = 1
            else
                percent = i.to_f / (num_legend_sizes - 1)
            end
            value = percent_to_value(percent)
            value = value.round(2) if value.kind_of? Float
            sizes << {
                :diameter => percent_to_size(percent) * 2,
                :value => value
            }
        end
        return sizes
    end

    def legend_colors(color_theme = nil)
        colors = []
        num_legend_colors = [data_map.num_legend_colors, num_unique_values].min
        num_legend_colors.times do |i|
            if num_legend_colors == 1 
                percent = 1
            else
                percent = i.to_f / (num_legend_colors - 1)
            end
            value = percent_to_value(percent)
            value = value.round(2) if value.kind_of? Float
            colors << {
                :color => percent_to_color(percent, color_theme),
                :value => value
            }
        end
        return colors
    end

    def percent_to_size(percent)
        return (data_map.max_spot_size - data_map.min_spot_size) * percent + data_map.min_spot_size
    end

    def percent_to_color(percent, color_theme = nil)
        if reverse_color_theme
            percent = 1.0 - percent
        end
        color_theme ||= data_map.color_theme
        gradient = color_theme.gradient
        percent_i = (percent * 100).floor
        lower_color = percent_i > 0 ? gradient[gradient.keys[gradient.keys.push(percent_i).sort!.index(percent_i) - 1]] : gradient[0]
        lower_key = gradient.key(lower_color)
        upper_color = gradient[gradient.keys[gradient.keys.sort!.index(lower_key) + 1]]
        new_percent = ((percent - lower_key.to_f / 100) / (gradient.key(upper_color) - lower_key) * 10000).round
        return Color::RGB.from_html(upper_color).mix_with(Color::RGB.from_html(lower_color), new_percent).html
    end

    def value_to_percent(value)
        min_value = place_fields.minimum(:value)
        max_value = place_fields.maximum(:value)
        if log_scale
            min_value = if min_value > 0 then Math::log10(min_value) else 0.0 end
            max_value = if max_value > 0 then Math::log10(max_value) else 0.0 end
            value = if value > 0 then Math::log10(value) else 0.0 end
        end
        return (max_value - min_value) == 0 ? 1 : (value - min_value) / (max_value - min_value)
    end

    def percent_to_value(percent)
        min_value = place_fields.minimum(:value)
        max_value = place_fields.maximum(:value)
        value = (max_value - min_value) * percent + min_value
        if datatype == 'yes_no'
            return data_map.value_to_yes_no(value)
        elsif log_scale
            min_value = if min_value > 0 then Math::log10(min_value) else 0.0 end
            max_value = if max_value > 0 then Math::log10(max_value) else 0.0 end
            value = 10.0**((max_value - min_value) * percent + min_value)
            if value == 1.0
                return 0.0
            else
                return value
            end
        else
            return value
        end
    end

    def num_unique_values
        return place_fields.select(:value).count(:distinct => true)
    end
end
