/**
 * Created by kalaomer on 24.09.2014.
 */

$(function() {
    var map = L.map('map').setView([41.0230, 29.0805], 11);

// add an OpenStreetMap tile layer
    L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);

// add a marker in the given location, attach some popup content to it and open the popup
/*    L.marker([51.5, -0.09]).addTo(map)
        .bindPopup('A pretty CSS3 popup. <br> Easily customizable.')
        .openPopup();
*/
});