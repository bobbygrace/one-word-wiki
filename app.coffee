express = require 'express'
bodyParser = require 'body-parser'

app = express()

app.use express.static(__dirname + '/public')
app.use bodyParser.json()

app.get "/*", (req, res) ->
  res.sendFile(__dirname + '/public/index.html')

app.post "/", (req, res) ->
  body = req.body

app.listen(8080)
