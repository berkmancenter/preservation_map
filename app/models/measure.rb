class Measure < ActiveRecord::Base
    has_many :place_measures
    has_many :places, :through => :place_measures
    belongs_to :geo_graph
    belongs_to :external_data_source
    scope :numeric, where(:datatype => 'numeric')
    scope :metadata, where(:datatype => 'metadata')
    scope :yes_no, where(:datatype => 'yes_no')
    scope :selectable, where(:datatype => ['numeric', 'yes_no'])

    def size(place)
        percent = value_to_percent(value(place))
        return percent_to_size(percent)
    end

    def color(place, color_theme = nil)
        percent = value_to_percent(value(place))
        return percent_to_color(percent, color_theme)
    end

    def value(place)
        if place_measures.find_by_place_id(place.id)
            return place_measures.find_by_place_id(place.id).value
        elsif external_data_source
            return external_data_source.value(place, self)
        end
    end

    def display_value(place)
        value = value(place)
        value = geo_graph.value_to_yes_no(value) if datatype == 'yes_no'
        return value
    end

    def metadata(place)
        return place_measures.find_by_place_id(place.id).metadata
    end

    def legend_sizes
        sizes = []
        num_legend_sizes = [geo_graph.num_legend_sizes, num_unique_values].min
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
        num_legend_colors = [geo_graph.num_legend_colors, num_unique_values].min
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
        return (geo_graph.max_spot_size - geo_graph.min_spot_size) * percent + geo_graph.min_spot_size
    end

    def percent_to_color(percent, color_theme = nil)
        if reverse_color_theme
            percent = 1.0 - percent
        end
        color_theme ||= geo_graph.color_theme
        gradient = color_theme.gradient
        percent_i = (percent * 100).floor
        lower_color = percent_i > 0 ? gradient[gradient.keys[gradient.keys.push(percent_i).sort!.index(percent_i) - 1]] : gradient[0]
        lower_key = gradient.key(lower_color)
        upper_color = gradient[gradient.keys[gradient.keys.sort!.index(lower_key) + 1]]
        new_percent = ((percent - lower_key.to_f / 100) / (gradient.key(upper_color) - lower_key) * 10000).round
        return Color::RGB.from_html(upper_color).mix_with(Color::RGB.from_html(lower_color), new_percent).html
    end

    def value_to_percent(value)
        min_value = place_measures.minimum(:value)
        max_value = place_measures.maximum(:value)
        if log_scale
            min_value = if min_value > 0 then Math::log10(min_value) else 0.0 end
            max_value = if max_value > 0 then Math::log10(max_value) else 0.0 end
            value = if value > 0 then Math::log10(value) else 0.0 end
        end
        return (max_value - min_value) == 0 ? 1 : (value - min_value) / (max_value - min_value)
    end

    def percent_to_value(percent)
        min_value = place_measures.minimum(:value)
        max_value = place_measures.maximum(:value)
        value = (max_value - min_value) * percent + min_value
        if datatype == 'yes_no'
            return geo_graph.value_to_yes_no(value)
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
        return place_measures.select(:value).count(:distinct => true)
    end
end
