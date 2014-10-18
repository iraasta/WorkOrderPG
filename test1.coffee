_ = require "underscore"


bigComputation = (a) ->
  tab = (a*20 for a in [1..10000] when a % 2 == 0 and Math.sqrt(a) > 1)
  res = _.reduce(tab, ((a, b) -> a + b), 10 )
  (String.fromCharCode a.charCodeAt(0)+1 for a in res.toString()).join("lol")


console.log(bigComputation(Number process.argv[2]))
