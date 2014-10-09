util = require "util"

class Logger
  constructor: (@appendFun, @clearFun) ->
    @messages = {}
    @actualTag = null
  log: (obj, tag) ->
    if @actualTag? or tag == @actualTag then @appendFun(util.format(obj))
    if not @messages[tag]? then @messages[tag] = [obj]
    else @messages[tag].push(obj);
  trace: (obj, tag) ->
    @log obj, tag
    @log (new Error).stack, tag
  showOnlyTag: (tag)->
    @clearFun()
    (@appendFun obj for tag, obj of @messages when tag == tag)
    @actualTag = tag;
  showAllTags: ()->
    @actualTag = null

module.exports = Logger;
