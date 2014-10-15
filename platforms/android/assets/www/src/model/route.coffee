_ = require "underscore"
LatLng = google.maps.LatLng;
class Route
  constructor: (points, alreadyAcquired, map) ->
    @points = points;
    @alreadyAcquired = 0
    @directionsService = new google.maps.DirectionsService();
    @map = map;
    @directionsDisplay = new google.maps.DirectionsRenderer({preserveViewport: true});

  checkIfAcquired : (pos) ->
    if @points.length == 0 then return
    point1 = {lat:pos.lat(), lng:pos.lng()};
    point2 = @points[@alreadyAcquired]
    if getDistance(point1, point2) < 5000
      @acquire();
      true
    else false

  acquire: () ->
    if (@points.length == @alreadyAcquired)
      "done!"
    else @alreadyAcquired++

  draw: (position) ->
    @map.raw_map.setZoom(15);
    @map.raw_map.panTo(position);
    if @points.length == 0 then return
    @directionsDisplay.setDirections({routes: []});
    # console.log(max)
    @directionsDisplay.setMap(@map.raw_map);
    @directionsDisplay.setPanel(document.getElementById('directions-panel'));
    request =
      origin: position
      #waypoints : ({location: new LatLng(loc.lat, loc.lng), stopover: false} for loc in @points[max].midpoints)
      destination : new LatLng(@points[@alreadyAcquired].lat, @points[@alreadyAcquired].lng),
      travelMode: google.maps.TravelMode.DRIVING
    @directionsService.route(request, (result, status) =>
      if (status == google.maps.DirectionsStatus.OK)
        console.log(this)
        @directionsDisplay.setDirections(result);
      else
        console.log("Failed directions...")
    )

exports.Route = Route;

rad = (x) ->
  return x * Math.PI / 180

getDistance = (p1, p2) ->
  R = 6378137;
  dLat = rad(p2.lat - p1.lat);
  dLong = rad(p2.lng - p1.lng);
  a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
  Math.cos(rad(p1.lat)) * Math.cos(rad(p2.lat)) *
  Math.sin(dLong / 2) * Math.sin(dLong / 2);
  c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  d = R * c;
  d;
