$ = require 'zeptojs'
{ render, div, text, p, span, a } = require 'teacup'
Backbone = require 'backbone'
Backbone.$ = $

class AppView extends Backbone.View

  getWord: ->
    "Taco"

  render: ->
    word = @getWord()

    html = render ->
      div ".container", ->
        p ".word", ->
          text word
        a "href": "#", "Edit"
        p ".quiet", "This is One Word Wiki, a wiki with only one word to edit."

    $("body").append html
    @

  renderWord: ->
    @


module.exports = AppView
