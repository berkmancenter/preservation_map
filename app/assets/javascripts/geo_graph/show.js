function place_spots() {
    $.getJSON(path, {
            color_measure: $('#geo_graph_color_measure_id').val(),
            size_measure: $('#geo_graph_size_measure_id').val(),
            color_theme: $('#geo_graph_color_theme_input :checked').val()
        }, function(data) {
            var spotFeatures = Array();
            var coords, place, diameter, html = '';

            places = data.places;
            spots.removeAllFeatures();

            for (i in data.legend_sizes) {
                diameter = data.legend_sizes[i].diameter - 2;
                html += '<div class="spot_size"><div class="spot_circle" style="width:' + diameter + 'px;height:' + diameter + 'px;"></div><div class="spot_value">' + data.legend_sizes[i].value + '</div></div>';
            }
            $('#sizes .spot_size').remove();
            $('#sizes').append(html);

            html = '';

            for (i in data.legend_colors) {
                html += '<div class="spot_color"><div class="spot_swatch" style="background-color:' + data.legend_colors[i].color + '"></div><div class="spot_value">' + data.legend_colors[i].value + '</div></div>';
            }
            $('#colors .spot_color').remove();
            $('#colors').append(html);

            for(i in places) {
                place = places[i];
                coords = new OpenLayers.LonLat(place.longitude, place.latitude).transform(standardProj, googleProj); 
                spotFeatures.push(
                    new OpenLayers.Feature.Vector(
                        new OpenLayers.Geometry.Point(coords.lon, coords.lat),
                        {
                            placeName: place.name,
                            colorMeasureValue: place.colorMeasureValue,
                            sizeMeasureValue: place.sizeMeasureValue
                        },
                        {
                            pointRadius: place.size,
                            fillColor: place.color
                        }
                    )
                );
            }

            spots.addFeatures(spotFeatures);
        }
    );
}
