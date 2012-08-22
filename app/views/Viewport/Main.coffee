class Viewport extends BaseView
  template: require('templates/Viewport')
  id: 'viewport'
  contentSelector: null


  initialize: ->
    @render()

  doRender: ->
    $('body').append @template()

module.exports = Viewport