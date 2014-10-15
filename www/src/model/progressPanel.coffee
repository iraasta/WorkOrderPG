class ProgressPanel
  constructor : (panel) ->
    @panel = panel;
  draw : (points, acquired) ->
    aldone = (String.fromCharCode "A".charCodeAt(0)+i for i in [0...acquired])
    console.log(aldone)
    percentage = acquired/points.length*100
    @panel.html("#{percentage.toFixed(2)}% <br/> Reached: #{aldone.join(", ")}")

module.exports.ProgressPanel = ProgressPanel;