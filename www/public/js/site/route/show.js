/**
 * Created by kalaomer on 25.09.2014.
 */

$(function() {

    map.init('map');

    for(var key in window.points)
    {
        var point = points[key];

        var marker = map.addMarker(point, {
            draggable: false
        });

        marker.getPopup().setContent(point.name);
    }
});