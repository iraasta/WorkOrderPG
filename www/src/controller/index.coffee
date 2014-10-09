require "../model/logger.coffee"
events = require "../model/events.coffee"
{Route} = require "./../model/route.coffee"
{MapAdapter}   = require "./../model/map.coffee"

route = map = null;

initSocket = ()->
  local = "127.0.0.1:9000"
  remote = 'http://192.168.1.116:9000/';
  sock = io.connect(remote);
  sock.on("connect", () ->
    $("#sockready").show();

  )
  sock.on events.workorder, (data) ->
    [objectives, alreadyAcquired] = data
    route = new Route(objectives, alreadyAcquired)
    route.draw(map)

initialize = () ->
  map = new MapAdapter("map-canvas");
  [objectives, alreadyAcquired] = getTestValues();
  route = new Route(objectives, alreadyAcquired, map)
  route.draw(new google.maps.LatLng(41.75,-87.85))
  i = 0;
  setInterval( ()=>
    route.acquire(i++);
    route.draw(new google.maps.LatLng(41.75,-87.85))
  , 6000)
  initSocket();

google.maps.event.addDomListener(window, 'load', initialize);

getTestValues = ()->
  posx = 41.850033
  posy= -87.6500523
  objectives = []
  objectives[0] = {lat: posx, lng: posy, midpoints: []}
  objectives[1] = {lat: posx-1, lng: posy-1, midpoints: []}
  objectives[2] = {lat: posx-2, lng: posy-2, midpoints: []}
  objectives[3] = {lat: posx-3, lng: posy-3, midpoints: []}
  [objectives,[]]

