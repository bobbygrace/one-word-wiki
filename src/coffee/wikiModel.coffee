$ = require 'zeptojs'
_ = require 'underscore'
Backbone = require 'backbone'
Backbone.$ = $

class WikiModel extends Backbone.Model

  fetchWord: ->
    $.ajax
      url: '/word'
      success: (data, status, xhr) =>
        word = data.word
        @setWord(word)
      error: (err) =>

  saveWord: (word) ->
    $.ajax
      type: 'POST'
      url: '/word'
      data: JSON.stringify({ word })
      contentType: 'application/json'

    @setWord(word)

  setWord: (word) ->
    @set({word: word})

module.exports = WikiModel
