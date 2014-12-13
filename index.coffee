AppView   = require './src/coffee/appView.coffee'
WikiModel = require './src/coffee/wikiModel.coffee'

new AppView({ model: new WikiModel }).render()
