spawn = (require "child_process").spawn

child = spawn("coffee", ["test1.coffee", 10])
child.stdout.on("data", (data)->
  console.log(data.toString())
)
