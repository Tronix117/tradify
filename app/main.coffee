# Defining global "namespace" for our app
window.ST =
  models: {}
  views: {}
  routers: {}
  collections: {}
  misc: {}
  paths: {}

autoload = ->
  # Debug stuff
  window.dl = console.log
  window._dii = {}
  window.di = (a = 0)-> 
    window._dii[a] = 0 unless window._dii[a]
    console.log a + '.' + window._dii[a]++

  vd = -> return null

  # Titanium placeholder
  if not `window.Titanium`
    window.Titanium = 
      UI: {getCurrentWindow: vd, createMenu: (-> appendItem:vd), createMenuItem: (-> addItem:vd), setMenu: vd}

  window.requireSafe = (f)->
    try return require(f) catch e
    return null

  # I18n configuration
  I18n = require 'utils/I18n'

  # Adding mixin
  _.mixin require 'utils/Mixin'
  
  # Base class
  window.BaseView = require 'views/Base'
  window.BaseRouter = require 'routers/Base'
  window.BaseCollection = require 'collections/Base'
  window.BaseModel = require 'models/Base'
  window.Constants = require 'utils/Constants'
  
  # Router autoloading
  for router in ['TopLevel']
    ST.routers[router] = new (require 'routers/'+router)

initContextMenu = ->

initMenu = ->
  menu = Titanium.UI.createMenu()
  file = Titanium.UI.createMenuItem("File")
  file.addItem "Open...", openTranslationFile
  file.addItem "Save", saveTranslationFile
  file.addItem "Scan file...", scanFile
  menu.appendItem file
  Titanium.UI.setMenu menu

# App bootstrapping on document ready
_.defer ->
  Titanium.UI.getCurrentWindow().showInspector true
  autoload()
  #initContextMenu()
  #initMenu()

  Backbone.history.start()
  Backbone.history.navigate 'home', true
