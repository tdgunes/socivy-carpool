/**
 * Created by kalaomer on 24.09.2014.
 */

$(function() {
    window.map.init('map');

    map._map.on('dblclick', function(e) {
        window.map.addMarker(e.latlng);
    });

    $('#route-form').submit(function() {
        var i;
        for(i=0; i<map.markers.length; i++) {
            var marker = map.markers[i];
            var coordinate = marker.getLatLng();

            var hiddenLatElement = document.createElement('input');
            hiddenLatElement.setAttribute('type', 'hidden');
            hiddenLatElement.setAttribute('name', 'point[' + i + '][lat]');
            hiddenLatElement.setAttribute('value', coordinate.lat);

            var hiddenLngElement = document.createElement('input');
            hiddenLngElement.setAttribute('type', 'hidden');
            hiddenLngElement.setAttribute('name', 'point[' + i + '][lng]');
            hiddenLngElement.setAttribute('value', coordinate.lng);

            var popupContent = $(marker.getPopup().getContent());
            var hiddenNameElement = document.createElement('input');
            hiddenNameElement.setAttribute('type', 'hidden');
            hiddenNameElement.setAttribute('name', 'point[' + i + '][lng]');
            hiddenNameElement.setAttribute('value', popupContent.find('.point-name').first().val());

            $('#route-form').append(hiddenLatElement);
            $('#route-form').append(hiddenLngElement);
            $('#route-form').append(hiddenNameElement);
        }
    });
});

(function() {
    var map = {
        markers: [],
        _map: null,
        options: {
            map: {
                doubleClickZoom: false
            },
            popup: {
                maxWidth: 300,
                minWidth: 200
            },
            startup: {
                view: [41.0230, 29.0805],
                zoom: 11
            }
        }
    };

    map.init = function(mapName) {
        this._map = L.map(mapName,this.options.map).setView(this.options.startup.view, this.options.startup.zoom);

        L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
        }).addTo(this._map);
    }

    map.addPopup = function(marker) {
        var popup = this.newPopup();
        var popupContent = $(popup.getContent());

        popupContent.find('button.delete-popup').click(function() {
            map._map.removeLayer(marker);

            map.removeMarker(marker);
        });

        popupContent.show();

        console.log('Popup added!', popup);

        marker.bindPopup(popup).openPopup();
    };

    map.removeMarker = function(marker)
    {
        for(var key in map.markers)
        {
            var _marker = map.markers[key];
            if(marker === _marker)
            {
                delete map.markers[key];
            }
        }
    }

    map.newPopup = function() {
        var popupContent = $('.point-popup').clone();

        var popup = L.popup(this.options.popup);

        popup.setContent(popupContent[0]);

        return popup;
    }

    /**
     *
     * @param marker
     */
    map.addMarker = function(coordinate) {

        var marker = L.marker(coordinate, {
            draggable: true
        });

        marker.addTo(this._map);

        this.markers.push(marker);
        this.addPopup(marker);
    }

    window.map = map;

})();