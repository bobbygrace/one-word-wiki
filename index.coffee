AppView   = require './src/coffee/appView.coffee'
EntryModel = require './src/coffee/entryModel.coffee'

new AppView({ model: new EntryModel }).render()
