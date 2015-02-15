$ = require 'zeptojs'
Backbone = require 'backbone'
Backbone.$ = $
socket = require('socket.io-client')("http://oneword.wiki/")
track = require './tracking.coffee'

class EntryModel extends Backbone.Model

  fetchWord: ->
    $.ajax
      url: '/word'
      success: (data, status, xhr) =>
        word = data
        @setWord(word)
      error: (err) =>

  saveWord: (word) ->
    $.ajax
      type: 'POST'
      url: '/word'
      data: JSON.stringify({ word })
      contentType: 'application/json'

    track('Word', word)

    socket.emit("word change", word)

    @setWord(word)

  setWord: (word) ->
    @set({word: word})

module.exports = EntryModel
