/**
 * Created by kalaomer on 25.09.2014.
 */

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
            },
            marker: {
                draggable: true
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

        marker.bindPopup(popup);
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
    map.addMarker = function(coordinate, _opt) {

        var opt = this.options.marker;

        if(_opt)
        {
            opt = $.extend({}, opt, _opt);
        }

        var marker = L.marker(coordinate, opt);

        marker.addTo(this._map);

        this.markers.push(marker);
        this.addPopup(marker);

        return marker;
    }

    map.updateMarkerPopupByCoordinate = function(marker, e) {

        this.getCoordinateInfo(e.latlng.lng, e.latlng.lat, function (data) {
            var popupContent = $(marker.getPopup().getContent());

            var address = data.address.county || data.address.town || data.address.suburb || data.address.state;
            popupContent.find('.point-name').first().val(address);
        });

    }

    map.getCoordinateInfo = function(lng, lat, callback) {
        $.get('http://nominatim.openstreetmap.org/reverse', {
            format: 'json',
            lat: lat,
            lon: lng
        }, function(data) {
            console.log('Coordinate Info', data);
            callback(data);
        },'json');
    }

    window.map = map;

})();