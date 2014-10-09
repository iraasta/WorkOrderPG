config = require("./../../config");


exports.setLanguage = (language) ->
  if not config.languages[language]? then throw new Error("There is no such language")
  if language != config.default_language
    file = require("./languages/" + language)
    for field, val of exports
      if file[field]? then exports[field] = file[field]
      else if typeof file[field] == "string" then throw new Error("No field with name #{field} in language #{language}")
  else init();

init = ()->
  exports.test = "the test"

init();