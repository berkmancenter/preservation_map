function place_spots() {
    $.getJSON(path, function(data) {
        places = data;
        var spotFeatures = Array();
        var coords;
        spots.removeAllFeatures();

        for(i in places) {
            coords = new OpenLayers.LonLat(places[i].longitude, places[i].latitude).transform(standardProj, googleProj); 
            spotFeatures.push(
                new OpenLayers.Feature.Vector(
                    new OpenLayers.Geometry.Point(coords.lon, coords.lat),
                    {
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
