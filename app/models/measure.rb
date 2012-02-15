class Measure < ActiveRecord::Base
    has_many :place_measures
    has_many :places, :through => :place_measures
    belongs_to :geo_graph

    def size(place_id)
        percent = place_measures.find_by_measure_id_and_place_id(id, place_id).to_percent
        return (geo_graph.max_spot_size - geo_graph.min_spot_size) * percent + geo_graph.min_spot_size
    end

    def color(place_id)
        percent = place_measures.find_by_measure_id_and_place_id(id, place_id).to_percent
        lower_key = percent < 1 ? (percent * 100).round / 25 * 25 : 75
        lower_color, upper_color = geo_graph.color_theme.values_at(lower_key, lower_key + 25).map { |color| Color::RGB.from_html(color) }
        return upper_color.mix_with(lower_color, (percent * 100).round).html
    end

    def value(place_id)
        place_measures.find_by_measure_id_and_place_id(id, place_id).value
    end
end
