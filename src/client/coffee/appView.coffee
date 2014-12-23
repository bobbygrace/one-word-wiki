$ = require 'zeptojs'
Backbone = require 'backbone'
Backbone.$ = $
_ = require 'underscore'
validateInput = require "../../shared/coffee/validator.coffee"
{ render, div, form, input, text, p, span, a } = require 'teacup'
socket = require('socket.io-client')("http://localhost:8080")

class AppView extends Backbone.View

  events:
    "click .js-edit": "edit"
    "submit .js-form": "save"
    "click .js-save": "save"
    "click .js-cancel": "cancel"
    "keyup .js-input": "keyupEvent"

  initialize: ->
    @fEditing = false
    @setElement $(".js-app")
    @listenTo @model, "change:word", @renderWord
    @listenTo socket, "word change", (word) =>
      @model.setWord(word)

  render: ->

    html = render ->
      div ".js-show-word", ->
        p ".word.js-word"
        a ".edit-button.js-edit", "href": "#", "Edit"
      div ".hidden.js-hide-word", ->
        form ".js-form", ->
          input ".edit-form-text.js-input", "type": "text"
          p ".error.hidden.js-error-invalid", ->
            span ".js-error-too-many-words.hidden", "Only one word is allowed. "
            span ".js-error-invalid-characters.hidden", "No spaces or punctuation (except hypens) are accepted. "
            text "Your word will be “"
            span ".js-validated-output"
            text "”."
          input ".edit-form-submit.edit-form-submit--primary.js-save", "type": "submit", "value": "Save"
          input ".edit-form-submit.js-cancel", "type": "submit", "value": "Cancel"
      p ".footer", ->
        text "Edit This Word is a web page with one word that anyone can edit. Created by "
        a "href": "http://bobbygrace.info", "Bobby Grace"
        text "."

    @$el.html html
    @model.fetchWord()

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
    @renderValidationErrors()
    @

  renderValidationErrors: ->
    inputValue = @$(".js-input").val()
    validated = validateInput(inputValue)

    if (validated.errorInvalidCharacters || validated.errorTooManyWords) && !validated.errorEmptyWord
      @$(".js-error-invalid-characters").toggleClass("hidden", !validated.errorInvalidCharacters)
      @$(".js-error-too-many-words").toggleClass("hidden", !validated.errorTooManyWords)
      @$(".js-validated-output").text validated.output

      @$(".js-error-invalid").removeClass("hidden")
    else
      @$(".js-error-invalid").addClass("hidden")

    @

  keyupEvent: ->
    @renderValidationErrors()

  edit: (e) ->
    e.preventDefault()
    @fEditing = true
    @renderEditState()
    false

  save: (e) ->
    e.preventDefault()

    inputValue = @$(".js-input").val()
    validated = validateInput(inputValue)

    @model.saveWord(validated.output)
    @$(".js-input").val("")
    @fEditing = false
    @renderEditState()
    false

  cancel: (e) ->
    e.preventDefault()
    @fEditing = false
    @renderEditState()
    false

module.exports = AppView
