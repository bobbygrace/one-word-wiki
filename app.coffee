express = require 'express'
app = express()

app.use express.static(__dirname + '/public')

app.get "/*", (req, res) ->
  res.sendfile(__dirname + '/public/index.html')

app.post "/", (req, res) ->
  console.log req

app.listen(8080)
