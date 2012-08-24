class Viewport extends BaseView
  template: require 'templates/Viewport'
  id: 'viewport'
  el: $ 'body'

  initialize: ->
    @render()
    #new (require 'views/Viewport/Menu')
    new (require 'views/Translate/Page')

module.exports = Viewport