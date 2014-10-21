yourPos = null

globals = require "../model/globals.coffee"
events = require "../model/events.coffee"
{GPS} = require "../model/gps.coffee"

pages =
  "workorder.html" : require "../controller/workorder.coffee"
  "dispatch.html" : {init:->}
  "profile.html" : {init:->}
  "chat.html" : {init:->}


initialize = () ->
  globals.gps = new GPS();
  initSocket();
  addPanelMenu();
  addPanelTabRouting();
  setGPSPositionUpdate();
  removeScrolling()
  loadPage globals.defaultPage,  ->
    $("#track-bt").on "click", trackBtClicked
    #setTimeout handleLogin, 2000

$(document).on 'ready', initialize


trackBtClicked = ()->
  bt = $("#track-bt")
  c = "ui-btn-active";
  if bt.hasClass c
    bt.removeClass c
    globals.setTrackme(false)
  else
    bt.addClass c
    globals.setTrackme(true)

initSocket = () ->
  remote = 'http://104.131.55.190:9001/';
  globals.sock =  io.connect(remote);
  globals.sock.on "connect", () ->
    console.log("connected")
  globals.sock.on events.success, ->
    [h,t...] = globals.nextResult
    if h? then h(true)
    globals.nextResult = t;

  globals.sock.on events.failure, ->
    [h,t...] = globals.nextResult
    if h? then h(false)
    globals.nextResult = t;




handleLogin = () ->
  $("body").pagecontainer("change", "#login", {role: "dialog"})
  $("#submit").on "click", ->
    globals.sock.emit events.logindriver, [$("#email").val(), $("#password").val()]
    globals.nextResult.push (success)->
      if success then $("body").pagecontainer("change", "")
      else $("#login-failed").show();

removeScrolling = () ->
  document.addEventListener 'touchmove', ((e)-> e.preventDefault()) , false

addPanelMenu = () ->
  $.event.special.swipe.horizontalDistanceThreshold = 12;
  $("#main-page").on "swiperight", () ->
    $("#directions-panel").panel("open")

  $(document).on 'click', '#menu-bt', ()->
    $.mobile.activePage.find('#directions-panel').panel("open")

  $(document).on 'click', '#panel-menu-bt', ()->
    $.mobile.activePage.find('#directions-panel').panel("close")

setGPSPositionUpdate = () ->
  globals.gps.every(60000, (a,b) => globals.sock.emit(events.position, [b.coords.latitude, b.coords.longitude]))
  0



addPanelTabRouting = () ->
  $(".page-tab").bind "click", (e) ->
    console.log "Click"
    loadPage(e.target.id)

loadPage = (page, cb)->
  $("#cont").load "html/#{page}.html", ->
    pages[page + ".html"].init()
    if cb then cb()