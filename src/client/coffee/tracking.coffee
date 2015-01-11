track = (Category, Action, Label, Value) ->
  ga 'send', 'event', Category, Action, Label, Value

module.exports = track
