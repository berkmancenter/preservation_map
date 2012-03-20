/*
 *= require application
 *= require openlayers/OpenLayers
 *= require jquery.qtip-1.0.0-rc3.min
 *= require_self
*/

var map, spot_layer, 
    standard_proj = new OpenLayers.Projection('EPSG:4326')
;

// Change OL theme
OpenLayers.ImgPath = asset_path + 'openlayers/';

// Create map in #map with controls
map = new OpenLayers.Map('map', { theme: null, 
    controls: [
        new OpenLayers.Control.ArgParser(),
        new OpenLayers.Control.Attribution(),
        new OpenLayers.Control.Navigation(),
        new OpenLayers.Control.PanZoomBar(),
        new OpenLayers.Control.KeyboardDefaults()
    ]
});

// Add base layer(s)
map.addLayer(new OpenLayers.Layer.Google('Google Streets', {
    isBaseLayer: true,
    numZoomLevels: datamap_zoom_levels
}));

// Add feature layer (with spots)
spot_layer = new OpenLayers.Layer.Vector('Spot Layer');
spot_layer.events.on({
    // Create popup when the spot is selected
    'featureselected': function(clicked) {
        var spot_data = clicked.feature.data;
        var popup_html =
            '<div>' +
                '<dl>' +
                    '<dt>Place: </dt>' +
                        '<dd>' + spot_data.placeName +'</dd>' +
                    '<dt>' + $('#data_map_size_measure_id option:selected').text() + ' (size): </dt>' +
                        '<dd>' + spot_data.sizeMeasureValue + '</dd>' +
                    '<dt>' + $('#data_map_color_measure_id option:selected').text() + ' (color): </dt>' +
                        '<dd>' + spot_data.colorMeasureValue + '</dd>';
            for (i in spot_data.metadata) {
                popup_html +=
                    '<dt>' + spot_data.metadata[i].name + '</dt>' +
                        '<dd>' + spot_data.metadata[i].data + '</dt>';
            }
            popup_html +=
                '</dl>' +
             '</div>';

        var popup = new OpenLayers.Popup.FramedCloud("place_info", 
            clicked.feature.geometry.getBounds().getCenterLonLat(),
            null,
            popup_html,
            null,
            true
        );
        clicked.feature.popup = popup;
        map.addPopup(popup);
    },
    'featureunselected': function(clicked) {
            map.removePopup(clicked.feature.popup);
            clicked.feature.popup.destroy();
            clicked.feature.popup = null;
    }
});
map.addLayer(spot_layer);

// Add select control to spots layer so spots can actually get selected
map.addControl(new OpenLayers.Control.SelectFeature(spot_layer, {toggle: true, autoActivate: true}));

// Put spots on the map
place_spots();

// Set default map center
if (typeof datamap_default_latitude != 'undefined' && typeof datamap_default_longitude != 'undefined') {
    map.setCenter(new OpenLayers.LonLat(datamap_default_longitude, datamap_default_latitude).transform(standard_proj, map.getProjectionObject()));
}

// Zoom to default zoom level
if (typeof datamap_default_zoom != 'undefined') {
    map.zoomTo(datamap_default_zoom);
}
else {
    map.zoomToMaxExtent();
}

// When the page is ready, add event handlers
$(function() {

    var qtipStyle = {
        style: {
            lineHeight: '14px',
            zIndex: 20000,
            border: {
                radius: 4,
                width: 4
            },
            tip: 'rightMiddle',
            name: 'green'
        },
        position: {
            corner: {
                target: 'leftMiddle',
                tooltip: 'rightMiddle'
            }
        }
    };

    // Update spots on settings change
    $('#datamap_settings').find('input, select').change(function() { place_spots(); } );

    // Show data table when button is clicked
    $('#hideTable').click(function() { $('table').toggle() });

    $('.help-texts').children().each(function() {
        $('#' + $(this).attr('id').slice(0, -5)).addClass('help');
    });

    $('.help').hover(
        function() {
            var helpIsHidden = $('#blinder').css('opacity') == 0;
            if (!helpIsHidden) {
                $(this).trigger('help:show');
            }
        },
        function() {
            $(this).trigger('help:hide');
        }
    );

    // Add titles to elements the first time help is loaded
    // Race condition?
    $('.activate-help').one('click', function() {
        $('.help').each(function() {
            $(this).attr('title', $('#' + $(this).attr('id') + '-help').text());
        });
    });

    $('.activate-help').click(function() {
        $(this).toggleClass('active');
        $('.help').toggleClass('help-active');
        $('#blinder').toggleClass('visible');
    });

    $('.activate-help').qtip($.extend({content:{text:'Toggle Help Mode'}}, qtipStyle));

    // Show help text
    $('.help').qtip($.extend({show:{when:{event:'help:show'}},hide:{when:{event:'help:hide'}}}, qtipStyle));

    // Fill in the default view form when the default view link is clicked
    if ($('#set-default-view')) {
        $('#set-default-view').attr('href', '#').click(function(e) {
            // What stupid ids
            var center = map.getCenter().transform(map.getProjectionObject(), standard_proj);
            $('#default_view_data_map_default_zoom_level').val(map.getZoom());
            $('#default_view_data_map_default_latitude').val(center.lat);
            $('#default_view_data_map_default_longitude').val(center.lon);
            $('#default_view_data_map_color_measure_id').val($('#data_map_color_measure_id').val());
            $('#default_view_data_map_size_measure_id').val($('#data_map_size_measure_id').val());
            $('#default_view_data_map_color_theme_id').val($('#data_map_color_theme_input input:checked').val());
            $('#default_view_form').submit();
        });
        $('#default_view_form').bind('ajax:success', function(e) { alert('Successfully set as default view'); });
    }
}); 

// Put the spots on the map
function place_spots() {
    $.getJSON(ajax_path, {
            color_measure: $('#data_map_color_measure_id').val(),
            size_measure: $('#data_map_size_measure_id').val(),
            color_theme: $('#data_map_color_theme_input :checked').val()
        },
        function(datamap) {
            // Setup vars
            var coords, places, diameter,
                legend_html = '',
                spots = []
            ;

            // Remove all spots
            spot_layer.removeAllFeatures();

            // Create legend html for size measure
            for (i in datamap.legend_sizes) {
                // Remove the border pixels from diameter so they match those on the map
                diameter = datamap.legend_sizes[i].diameter - 1 * 2;
                legend_html +=
                    '<div class="spot_size">' +
                        '<div class="spot_circle" style="width:' + diameter + 'px;height:' + diameter + 'px;"></div>' +
                        '<div class="spot_value">' + datamap.legend_sizes[i].value + '</div>' +
                    '</div>'
                ;
            }

            // Remove size measure legend items and add new ones
            $('#sizes .spot_size').remove();
            $('#sizes').append(legend_html).find('#size-title').text( $('#data_map_size_measure_id :selected').text() );

            // Reset to add color info
            legend_html = '';

            // Create legend html for color measure
            for (i in datamap.legend_colors) {
                legend_html +=
                    '<div class="spot_color">' +
                        '<div class="spot_swatch" style="background-color:' + datamap.legend_colors[i].color + '"></div>' +
                        '<div class="spot_value">' + datamap.legend_colors[i].value + '</div>' +
                    '</div>'
                ;
            }

            // Remove color measure legend items and add new ones
            $('#colors .spot_color').remove();
            $('#colors').append(legend_html).find('#color-title').text( $('#data_map_color_measure_id :selected').text() );

            // Add a spot for each place
            for(i in datamap.places) {
                place = datamap.places[i];
                // Calculate the latlong for the spot
                coords = new OpenLayers.LonLat(place.longitude, place.latitude).transform(standard_proj, map.getProjectionObject()); 
                spots.push(
                    new OpenLayers.Feature.Vector(
                        new OpenLayers.Geometry.Point(coords.lon, coords.lat),
                        {
                            placeName: place.name,
                            colorMeasureValue: place.colorMeasureValue,
                            sizeMeasureValue: place.sizeMeasureValue,
                            metadata: place.metadata
                        },
                        {
                            pointRadius: place.size,
                            fillColor: place.color
                        }
                    )
                );
            }

            spot_layer.addFeatures(spots);
        }
    );
}
