express = require 'express'
bodyParser = require 'body-parser'
st = require 'st'

app = express()
app.use bodyParser.json()

app.use(st({
  path: __dirname + '/public'
  url: '/'
  index: "index.html"
}))

app.post "/", (req, res) ->
  body = req.body

app.listen(8080)
