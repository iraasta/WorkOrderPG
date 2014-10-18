yourPos = null
DEBUG = false;

require "../model/logger.coffee"
events = require "../model/events.coffee"
{Route} = require "./../model/route.coffee"
{MapAdapter}   = require "./../model/map.coffee"
{GPS} = require "./../model/gps.coffee"
{ProgressPanel} = require "./../model/progressPanel.coffee"
LatLng = google.maps.LatLng;

route = progress = map = gps = sock  =  null;
trackme  = lastposition = null;

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
    console.log(data);
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
  google.maps.event.addListener map, 'drag', () -> trackBtClicked()
  $("#track-bt").on "click", trackBtClicked
  getPosition (latlng) -> route.pan(latlng)


  setTimeout handleLogin, 2000


google.maps.event.addDomListener(window, 'load', initialize);

getPosition =(cb)->
  if(DEBUG)
    posx = 41.850033
    posy= -73.93
    objectives = []
    lastposition = new LatLng(posx, posy)
    cb new LatLng(posx, posy)
  else
    gps.getLatLng (latlng)->
      lastposition = latlng;
      cb(latlng)

drawAll = ()->
  getPosition (pos)->
    if route
      route.draw(pos)
      if route.checkIfAcquired(pos)
        progress.draw(route.points, route.alreadyAcquired)
    if trackme
      route.pan(lastposition);



trackBtClicked = ()->
  bt = $("#track-bt")
  c = "ui-btn-active";
  if bt.hasClass c
    bt.removeClass c
    trackme = false
  else
    bt.addClass c
    trackme = true
    drawAll()


handleLogin = ()->
  $("body").pagecontainer("change", "#login", {role: "dialog"})
  $("#submit").on "click", ()->
    console.log("LOL")
