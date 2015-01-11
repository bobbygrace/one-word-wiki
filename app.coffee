path = require 'path'
express = require 'express'
bodyParser = require 'body-parser'
st = require 'st'
app = express()
http = require('http').Server(app)
io = require('socket.io')(http)
validateInput = require './src/shared/coffee/validator.coffee'
fs = require 'fs'

app.use bodyParser.json()


# Sockets

io.on 'connection', (socket) ->

  socket.on 'word change', (word) ->
    io.emit 'word change', word


# Some routes

wordFile = './word.txt'

app.get '/word', (req, res, next) ->
  fs.readFile wordFile, 'utf8', (err, data) =>
    word = data
    res.send(word)

app.post '/word', (req, res, next) ->
  body = req.body
  word = validateInput(body.word).output
  fs.writeFile wordFile, word, 'utf8'


# Static Content

mount = st
  path: __dirname + '/public'
  url: '/'
  index: 'index.html'

app.use(mount)


# Start

http.listen(8080)
