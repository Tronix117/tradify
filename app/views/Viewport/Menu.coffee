Translator = require 'utils/Translator'

class MenuView extends BaseView
  template: require 'templates/Menu'
  id: 'menu'
  el: '#viewport'

  events:
    'click #action-scan button': 'scanAction'
    'click #action-open button': 'openAction'

  initialize: ->
    @render()

  scanAction: ->
    Titanium.UI.getCurrentWindow().openFileChooserDialog (filesPath)->
      ST.misc.currentScannedFile = Titanium.Filesystem.getFile(filesPath[0])
      ST.misc.scannedTranslations = Translator.findStringsToTranslate(ST.misc.currentScannedFile.read())
      new (require 'views/Translate/Page')

  openAction: ->
    Titanium.UI.getCurrentWindow().openFileChooserDialog (filesPath)->
      ST.misc.currentTranslationFile = Titanium.Filesystem.getFile(filesPath[0])
      new (require 'views/Translate/Page')


module.exports = MenuView