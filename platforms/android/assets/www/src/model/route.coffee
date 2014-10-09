_ = require "underscore"
LatLng = google.maps.LatLng;
class Route
  constructor: (points, alreadyAcquired, map) ->
    @points = points;
    @alreadyAcquired = alreadyAcquired;
    @directionsService = new google.maps.DirectionsService();
    @map = map;
    @directionsDisplay = new google.maps.DirectionsRenderer();
    @acquireCb = ->

  acquire: (point) ->
    @alreadyAcquired.push(point)

  setOnAcquire: (cb) ->
    @acquireCb = cb
  draw: (position) ->
    @directionsDisplay.setDirections({routes: []});
    max = -1;
    if @alreadyAcquired.length > 0 then max = _.max(@alreadyAcquired)
    # console.log(max)
    @directionsDisplay.setMap(@map.raw_map);
    request =
      origin: position
      #waypoints : ({location: new LatLng(loc.lat, loc.lng), stopover: false} for loc in @points[max].midpoints)
      destination : new LatLng(@points[max+1].lat, @points[max+1].lng),
      travelMode: google.maps.TravelMode.DRIVING
    @directionsService.route(request, (result, status) =>
      if (status == google.maps.DirectionsStatus.OK)
        console.log(this)
        @directionsDisplay.setDirections(result);
      else
        console.log("Failed")
    )

exports.Route = Route;