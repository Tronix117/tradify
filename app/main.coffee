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

  # I18n configuration
  I18n = require 'utils/I18n'
  I18n.locale = 'en'
  I18n.globalize()

  # Adding mixin
  _.mixin require 'utils/Mixin'
  _.mixin I18n
  
  # Base class
  window.BaseView = require 'views/Base'
  window.BaseRouter = require 'routers/Base'
  window.BaseCollection = require 'collections/Base'
  window.BaseModel = require 'models/Base'
  
  # Router autoloading
  for router in ['TopLevel']
    ST.routers[router] = new (require 'routers/'+router)

# App bootstrapping on document ready
_.defer ->
  autoload()

  Backbone.history.start()
  Backbone.history.navigate 'home', true
