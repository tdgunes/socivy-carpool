/**
 * Created by kalaomer on 24.09.2014.
 */

$(function() {
    window.map.init('map');

    map._map.on('dblclick', function(e) {
        var marker = window.map.addMarker(e.latlng);

        getCoordinateInfo(e.latlng.lng, e.latlng.lat, function (data) {
            var popupContent = $(marker.getPopup().getContent());

            var address = data.address.county || data.address.town || data.address.suburb;
            popupContent.find('.point-name').first().val(data.address.county);
        });
    });

    $('#route-form').submit(function(e) {

        if(map.markers.length == 0)
        {
            $('#map-point-error').show();
            e.preventDefault();
        }

        var i;
        for(i=0; i<map.markers.length; i++) {
            var marker = map.markers[i];
            var coordinate = marker.getLatLng();

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
            hiddenNameElement.setAttribute('value', popupContent.find('.point-name').first().val());

            $('#route-form').append(hiddenLatElement);
            $('#route-form').append(hiddenLngElement);
            $('#route-form').append(hiddenNameElement);
        }
    });
});

function getCoordinateInfo(lng, lat, callback) {
    $.get('http://nominatim.openstreetmap.org/reverse', {
        format: 'json',
        lat: lat,
        lon: lng
    }, function(data) {
        callback(data);
    },'json');
}