function place_spots() {
    $.getJSON(path, {
            color_measure: $('#geo_graph_color_measure_id').val(),
            size_measure: $('#geo_graph_size_measure_id').val(),
            color_theme: $('#geo_graph_color_theme_input :checked').val()
        }, function(data) {
        places = data.places;
        var spotFeatures = Array();
        var coords;
        spots.removeAllFeatures();

        for(i in places) {
            coords = new OpenLayers.LonLat(places[i].longitude, places[i].latitude).transform(standardProj, googleProj); 
            spotFeatures.push(
                new OpenLayers.Feature.Vector(
                    new OpenLayers.Geometry.Point(coords.lon, coords.lat),
                    {
                        placeName: places[i].name,
                        colorMeasureValue: places[i].colorMeasureValue,
                        sizeMeasureValue: places[i].sizeMeasureValue
                    },
                    {
                        pointRadius: places[i].size,
                        fillColor: places[i].color
                    }
                )
            );
        }

        spots.addFeatures(spotFeatures);
    });
}
