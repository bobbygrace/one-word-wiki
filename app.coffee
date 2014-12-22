path = require 'path'
express = require 'express'
bodyParser = require 'body-parser'
st = require 'st'
app = express()
http = require('http').Server(app)
io = require('socket.io')(http)

app.use bodyParser.json()

dbFile = path.join __dirname, "db.sqlite"
dbConfig = {
  client: 'sqlite',
  connection: {
    filename: dbFile
  }
}
knex = require('knex')(dbConfig)
bookshelf = require('bookshelf')(knex)


# Create a schema, if needed

createTable = ->
  bookshelf.knex.schema.createTable "Words", (table) ->
    table.increments "id"
    table.string "dateAdded"
    table.string "word"

bookshelf.knex.schema.hasTable("Words").then (exists) ->
  if !exists
    createTable()


# Sockets

io.on "connection", (socket) ->

  socket.on "word change", (word) ->
    io.emit "word change", word


# Models

Entry = bookshelf.Model.extend
  tableName: "Words"

Words = bookshelf.Collection.extend
  model: Entry

words = new Words
words.fetch()


# Some routes

app.get "/word", (req, res, next) ->
  word = words.models[words.length - 1]
  res.send(word)

app.post "/word", (req, res, next) ->
  body = req.body
  word = body.word
  dateAdded = (new Date()).toJSON()
  word = new Entry({word, dateAdded})
  words.create(word)


# Static Content

mount = st
  path: __dirname + '/public'
  url: '/'
  index: "index.html"

app.use(mount)


# Start

http.listen(8080)
