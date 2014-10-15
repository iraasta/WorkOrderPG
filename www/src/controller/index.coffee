require "../model/logger.coffee"
events = require "../model/events.coffee"
{Route} = require "./../model/route.coffee"
{MapAdapter}   = require "./../model/map.coffee"
{GPS} = require "./../model/gps.coffee"
{ProgressPanel} = require "./../model/progressPanel.coffee"
LatLng = google.maps.LatLng;

route = progress = map = gps = sock  =  null;

initSocket = ()->
  local = "127.0.0.1:9000"
  remote = 'http://104.131.55.190:9001/';
  sock = io.connect(remote);
  sock.on("connect", () ->
    console.log("connected")
    sock.emit events.logindriver, ["test@test.com", "w1"]

    gps.every(5000, (e,p) ->
      drawAll()

    )
  )

  sock.on events.success, (success) ->
    console.log("success") if success
  sock.on events.failure, (success) ->
    console.log("falure") if success
  sock.on events.workorder, (data) ->
    map.raw_map.get
    [objectives, alreadyAcquired] = data
    console.log([objectives, alreadyAcquired])
    route.points = objectives
    drawAll()


initialize = () ->
  gps = new GPS();
  map = new MapAdapter("map-canvas");
  route = new Route([], 0, map)
  progress = new ProgressPanel($("#testbt"))

  initSocket();
  gps.every(60000, (a,b) => sock.emit(events.position, [b.coords.latitude, b.coords.longitude]))


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

getTestPosition =()->
  posx = -33.8684944
  posy= 151.20788250000007
  new LatLng(posx, posy)

drawAll = ()->
  if route?
    route.draw(getTestPosition())
    if route.checkIfAcquired(getTestPosition())
      progress.draw(route.points, route.alreadyAcquired)