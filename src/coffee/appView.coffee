$ = require 'zeptojs'
{ render, div, form, input, text, p, span, a } = require 'teacup'
Backbone = require 'backbone'
Backbone.$ = $

class AppView extends Backbone.View

  events:
    "click .js-edit": "edit"
    "submit .js-form": "save"
    "click .js-save": "save"
    "click .js-cancel": "cancel"

  initialize: ->
    @fEditing = false
    @setElement $(".js-app")
    @listenTo @model, "change:word", @renderWord

  render: ->

    html = render ->
      div ".js-show-word", ->
        p ".word.js-word"
        a ".js-edit", "href": "#", "Edit"
      div ".hidden.js-hide-word", ->
        form ".js-form", ->
          input ".js-input", "type": "text"
        a ".js-save", "href": "#", "Save"
        a ".js-cancel", "href": "#", "Cancel"
      p ".quiet", "This is One Word Wiki, a wiki with only one word to edit."

    @$el.html html

    @renderWord()

    @

  renderWord: ->
    @$(".js-word").text @model.get("word")
    @

  renderEditState: ->
    @$(".js-show-word").toggleClass("hidden", @fEditing)
    @$(".js-hide-word").toggleClass("hidden", !@fEditing)
    if @fEditing
      @$(".js-input").focus()
      @$(".js-input")[0].select()
    @

  edit: (e) ->
    e.preventDefault()
    @fEditing = true
    @renderEditState()
    false

  save: (e) ->
    e.preventDefault()
    value = @$(".js-input").val().trim()
    @model.setWord(value)

    @fEditing = false
    @renderEditState()
    false

  cancel: (e) ->
    e.preventDefault()
    @fEditing = false
    @renderEditState()
    false

module.exports = AppView
