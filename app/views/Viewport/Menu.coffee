class MenuView extends BaseView
  template: require 'templates/Menu'
  id: 'menu'
  el: '#viewport'

  events:
    'click .action-scan': 'scanAction'
    'click .action-open': 'openAction'

  initialize: ->
    @render()

  scanAction: ->
    

  openAction: ->
    


module.exports = MenuView