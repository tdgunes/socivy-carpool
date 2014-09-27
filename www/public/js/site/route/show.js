/**
 * Created by kalaomer on 25.09.2014.
 */

$(function() {

    map.init('map');

    for(var key in window.points)
    {
        var point = points[key];

        var greenMarker = L.AwesomeMarkers.icon({
            icon: 'map-marker',
            markerColor: 'green'
        });

        var marker = map.createMarker(point, {
            draggable: false,
            icon: greenMarker
        });

        marker.getPopup().setContent(point.name);
    }
});