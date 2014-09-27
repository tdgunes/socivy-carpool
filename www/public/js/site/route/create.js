/**
 * Created by kalaomer on 24.09.2014.
 */

"use strict";

$(function() {
    window.map.init('map');

    $.each(window.points, function(index, point) {

        var redMarker = L.AwesomeMarkers.icon({
            icon: 'map-marker',
            markerColor: 'red'
        });

        var greenMarker = L.AwesomeMarkers.icon({
            icon: 'map-marker',
            markerColor: 'green'
        });

        var marker = map.createMarker(point, {
            draggable: false,
            icon: redMarker
        });

        marker._pointData = point;

        var popup = marker.getPopup();

        var popupContent = $(popup.getContent());

        popupContent.find('.point-name').html(point.name);

        popupContent.find('.add-to-route').click(function() {
            marker.setIcon(greenMarker);
            window.map.addMarker(marker);
            $(this).hide().parent().find('.remove-from-route').show();
        });

        popupContent.find('.remove-from-route').click(function() {
            marker.setIcon(redMarker);
            window.map.removeMarker(marker);
            $(this).hide().parent().find('.add-to-route').show();
        });

    });

    /*
    map._map.on('dblclick', function(e) {
        var marker = window.map.addMarker(e.latlng);

        window.map.updateMarkerPopupByCoordinate(marker, e);

        // Sırf fazla request atmasın diye Marker içinde tut noktayı, sonra çekeriz bilgileri!
        marker.on('move', function(e) {
            marker._lastCoordinate = e;
        });

        marker.on('dragend', function(e) {
            window.map.updateMarkerPopupByCoordinate(marker, marker._lastCoordinate);
        });
    });
    */

    $('#route-form').submit(function(e) {

        if(map.markers.length == 0)
        {
            $('#map-point-error').show();
            e.preventDefault();
        }

        var i;
        for(i=0; i<map.markers.length; i++) {
            var marker = map.markers[i];
            var coordinate = marker._pointData;

            // TODO: Bu kısım çok kirli, buraya sonradan bir uğra! :/

            var hiddenLatElement = document.createElement('input');
            hiddenLatElement.setAttribute('type', 'hidden');
            hiddenLatElement.setAttribute('name', 'points[' + i + '][lat]');
            hiddenLatElement.setAttribute('value', coordinate.lat);

            var hiddenLngElement = document.createElement('input');
            hiddenLngElement.setAttribute('type', 'hidden');
            hiddenLngElement.setAttribute('name', 'points[' + i + '][lng]');
            hiddenLngElement.setAttribute('value', coordinate.lng);

            var popupContent = $(marker.getPopup().getContent());
            var hiddenNameElement = document.createElement('input');
            hiddenNameElement.setAttribute('type', 'hidden');
            hiddenNameElement.setAttribute('name', 'points[' + i + '][name]');
            hiddenNameElement.setAttribute('value', coordinate.name);

            $('#route-form').append(hiddenLatElement);
            $('#route-form').append(hiddenLngElement);
            $('#route-form').append(hiddenNameElement);
        }
    });
});