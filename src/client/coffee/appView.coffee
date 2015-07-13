$ = require 'zeptojs'
Backbone = require 'backbone'
Backbone.$ = $
_ = require 'underscore'
validateInput = require "../../shared/coffee/validator.coffee"
{ render, div, form, input, text, ul, li, p, strong, span, a, raw } = require 'teacup'
socket = require('socket.io-client')("http://oneword.wiki/")

class AppView extends Backbone.View

  events:
    'click .js-edit': 'edit'
    'submit .js-form': 'save'
    'click .js-save': 'save'
    'click .js-cancel': 'cancel'
    'keyup .js-input': 'keyupEvent'
    'click .js-expand-what': 'expandWhat'
    'click .js-collapse-what': 'collapseWhat'

  initialize: ->
    @fEditing = false
    @setElement $(".js-app")
    @listenTo @model, "change:word", @renderWord
    @listenTo socket, "word change", (word) =>
      @model.setWord(word)

  render: ->

    html = render ->
      div ".js-show-word", ->
        p ".word.js-word", ->
          raw "&nbsp;"
        a ".edit-button.js-edit", "href": "#", "Edit"
      div ".hidden.js-hide-word", ->
        form ".js-form", ->
          input ".edit-form-text.js-input", "type": "text"
          p ".error.hidden.js-error-invalid", ->
            span ".js-error-too-many-words.hidden", "Only one word is allowed. "
            span ".js-error-invalid-characters.hidden", "No spaces or punctuation (except hyphens) are accepted. "
            text "Your word will be “"
            span ".js-validated-output"
            text "”."
          input ".edit-form-submit.edit-form-submit--primary.js-save", "type": "submit", "value": "Save"
          input ".edit-form-submit.js-cancel", "type": "submit", "value": "Cancel"
      div ".footer.js-footer", ->
        div ".footer-collapsed", ->
          p ->
            a "class": "js-expand-what", "href": "#", "What is this?"
        div ".footer-expanded", ->
          p "One Word Wiki is a web page with one word that anyone can edit."
          p "Just click the edit button, write a new word, and save it. Everyone will be able to see the new word and anyone can come along and change it. If someone changes the word while you’re on the page, the word will update in real time. No need to refresh."
          p "No word will be censored or edited in any way except according to the three following rules:"
          ul ->
            li ->
              p ->
                text "The word "
                strong "can’t be empty"
                text "."
            li ->
              p ->
                text "The word "
                strong "can’t have spaces"
                text ". If you have any spaces, it will take the word before the first space."
            li ->
              p ->
                text "The word "
                strong "can’t have any punctuation"
                text " except hyphens. If there is other punctuation, it will take the word before the first punctuation mark."
          p "All changes are anonymous. There is no way to make an account or give an email address. The site doesn’t care who you are. However, the site will be anonymously tracking changes to the word so that it can be analyzed for trends. It will not track IP addresses or attempt to identify individuals."
          p ->
            text "This website was made by "
            a "href": "http://bobbygrace.info", "Bobby Grace"
            text "."
          p ->
            a "class": "js-collapse-what", "href": "#", "Got it. Hide this."

    @$el.html html
    @model.fetchWord()

    @

  expandWhat: (e) ->
    e.preventDefault()
    @$('.js-footer').addClass('is-expanded')
    false

  collapseWhat: (e) ->
    e.preventDefault()
    @$('.js-footer').removeClass('is-expanded')
    false

  renderWord: ->
    document.title = "#{@model.get("word")} » OneWord.Wiki"
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

    if validated.errorEmptyWord
      return false

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
