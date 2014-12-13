Backbone = require 'backbone'

class WikiModel extends Backbone.Model

  defaults: ->
    ls = JSON.parse localStorage.getItem("wiki")
    {
      word: ls?["word"] ? "Word"
    }

  set: ->
    super
    localStorage.setItem("wiki", JSON.stringify(@attributes))

  setWord: (word) ->
    @set({word: word})

module.exports = WikiModel
