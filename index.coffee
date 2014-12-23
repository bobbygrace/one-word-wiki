AppView   = require './src/client/coffee/appView.coffee'
EntryModel = require './src/client/coffee/entryModel.coffee'

new AppView({ model: new EntryModel }).render()
