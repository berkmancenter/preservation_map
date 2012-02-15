function place_spots() {
    var map = new OpenLayers.Map('map');
    var base = new OpenLayers.Layer.Google("Google Streets", { isBaseLayer: true, numZoomLevels: 20 });
    map.addLayer(base);
    map.zoomToMaxExtent();
    var googleProj = map.getProjectionObject();
    var standardProj = new OpenLayers.Projection('EPSG:4326');
    var spotFeatures = Array();

    var spots = new OpenLayers.Layer.Vector("Spots");

    for(i in places) {
        var coords = new OpenLayers.LonLat(places[i].longitude, places[i].latitude).transform(standardProj, googleProj); 
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
    map.addLayer(spots);
    map.setCenter(coords);
    map.zoomTo(16);
}
