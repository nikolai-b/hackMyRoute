var map = L.map('map').setView([53.797, -1.55], 13);
var token = 'pk.eyJ1IjoiYWxleGZyb3N0IiwiYSI6IkxWNGlmMjgifQ.1f4F5qrMT0IKQSog8M1TCQ';
L.tileLayer('http://{s}.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=' + token, {
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
    maxZoom: 18,
    id: 'alexfrost.l3jdmm0g'
}).addTo(map);
