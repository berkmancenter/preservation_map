$(function() {
    var places = [
        {
            name: 'Widener Library',
            latitude: 42.373397,
            longitude: -71.11653,
            size: 15,
            color: '#0F0',
            colorMeasure: 4.2,
            sizeMeasure: 112000
        },
        {
            name: 'Pusey Library',
            latitude: 42.373201,
            longitude: -71.115602,
            size: 10,
            color: '#0FF',
            colorMeasure: 4.2,
            sizeMeasure: 112000
        }
    ];

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
                    colorMeasure: places[i].colorMeasure,
                    sizeMeasure: places[i].sizeMeasure
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
});
