class MapAdapter
  constructor: (domId)->
    mapOptions = {
      zoom: 12,
      center: new google.maps.LatLng(0, 0)
    };
    @raw_map = new google.maps.Map($(domId).get(0), mapOptions);
    @markers = []

  addMarker: (lat,lng, color = "yellow")->
    myLatlng = new google.maps.LatLng(lat, lng);
    mark = new google.maps.Marker({
      position: myLatlng,
      map: @raw_map,
      title: 'Marker'
    });
    mark.setIcon("http://maps.google.com/mapfiles/ms/icons/#{color}-dot.png");
    @markers.push(mark)


module.exports.MapAdapter = MapAdapter;