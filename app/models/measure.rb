class Measure < ActiveRecord::Base
    has_many :place_measures
    has_many :places, :through => :place_measures
    belongs_to :geo_graph

    def size(place)
        percent = place_measures.find_by_measure_id_and_place_id(id, place.id).to_percent
        return (geo_graph.max_spot_size - geo_graph.min_spot_size) * percent + geo_graph.min_spot_size
    end

    def color(place)
        theme = geo_graph.color_theme.gradient
        percent = place_measures.find_by_measure_id_and_place_id(id, place.id).to_percent
        percent_i = (percent * 100).floor
        lower_color = percent_i > 0 ? theme[theme.keys[theme.keys.push(percent_i).sort!.index(percent_i) - 1]] : theme[0]
        lower_key = theme.key(lower_color)
        upper_color = theme[theme.keys[theme.keys.sort!.index(lower_key) + 1]]
        new_percent = ((percent - lower_key.to_f / 100) / (theme.key(upper_color) - lower_key) * 10000).round
        return Color::RGB.from_html(upper_color).mix_with(Color::RGB.from_html(lower_color), new_percent).html
    end

    def value(place)
        place_measures.find_by_measure_id_and_place_id(id, place.id).value
    end
end
