class Measure < ActiveRecord::Base
    has_many :place_measures
    has_many :places, :through => :place_measures
    belongs_to :geo_graph

    def size(place)
        percent = value_to_percent(value(place))
        return percent_to_size(percent)
    end

    def color(place, color_theme = nil)
        percent = value_to_percent(value(place))
        return percent_to_color(percent, color_theme)
    end

    def value(place)
        place_measures.find_by_place_id(place.id).value
    end

    def legend_sizes
        sizes = []
        geo_graph.num_legend_sizes.times do |i|
            percent = i.to_f / (geo_graph.num_legend_sizes - 1)
            sizes << {
                :diameter => percent_to_size(percent) * 2,
                :value => percent_to_value(percent)
            }
        end
        return sizes
    end

    def legend_colors(color_theme = nil)
        colors = []
        geo_graph.num_legend_colors.times do |i|
            percent = i.to_f / (geo_graph.num_legend_sizes - 1)
            colors << {
                :color => percent_to_color(percent, color_theme),
                :value => percent_to_value(percent)
            }
        end
        return colors
    end

    def percent_to_size(percent)
        return (geo_graph.max_spot_size - geo_graph.min_spot_size) * percent + geo_graph.min_spot_size
    end

    def percent_to_color(percent, color_theme = nil)
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
        return (max_value - min_value) == 0 ? 1 : (value - min_value) / (max_value - min_value)
    end

    def percent_to_value(percent)
        min_value = place_measures.minimum(:value)
        max_value = place_measures.maximum(:value)
        return (max_value - min_value) * percent + min_value
    end
end
