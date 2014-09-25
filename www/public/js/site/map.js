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

        return marker;
    }

    window.map = map;

})();