/**
 * Created by kalaomer on 24.09.2014.
 */

$(function() {
    var map = L.map('map').setView([41.0230, 29.0805], 11);

// add an OpenStreetMap tile layer
    L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);

    window._map = map;

    window.markers.map = map;

// add a marker in the given location, attach some popup content to it and open the popup
/*    L.marker([51.5, -0.09]).addTo(map)
        .bindPopup('A pretty CSS3 popup. <br> Easily customizable.')
        .openPopup();
*/
    map.on('click', function(e) {
        window.markers.add(e.latlng);
    });
});

(function() {
    var markers = {
        data: [],
        popups: null,
        map: null,
        popup: {
            options: {
                maxWidth: 300,
                minWidth: 200
            }
        }
    };

    markers.addPopup = function(marker) {
        var popup = this.newPopup();
        var popupContent = $(popup.getContent());

        popupContent.find('button.delete-popup').click(function() {
            markers.map.removeLayer(marker);
        });

        popupContent.show();

        console.log('Popup added!', popup);

        marker.bindPopup(popup).openPopup();
    };

    markers.newPopup = function() {
        var popupContent = $('.point-popup').clone();

        var popup = L.popup(this.popup.options);

        popup.setContent(popupContent[0]);

        return popup;
    }

    /**
     *
     * @param marker
     */
    markers.add = function(coordinate) {

        var marker = L.marker(coordinate, {
            draggable: true
        });

        marker.addTo(this.map);

        this.data.push(marker);
        this.addPopup(marker);
    }

    window.markers = markers;

})();