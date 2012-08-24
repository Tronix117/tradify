itemView = require 'views/Translate/Item'
menuBar = require 'templates/Translate/MenuBar'
translationsCollection = require 'collections/Translations'

class TranslatePageView extends BaseView
  template: require 'templates/Translate/Page'
  id: 'translate-page'
  el: '#viewport'

  events:
    'click .action-open': 'openTranslations'
    'click .action-save': 'saveTranslations'
    'click .action-scan': 'scanFile'

  initialize: ->
    @render()
    @enhance()

  enhance: ->
    $(@el).prepend menuBar()

  displayItems: ->
    for model in translationsCollection.models
      new itemView
        model: model
        el: $('<div class="translate-item"></div>').appendTo('#translate-page')

    randTitle = [
      '– Translate everything! –'
      '– How can I help you today? –'
      '– Ready for an awesome translation session? –'
      '– I like making your job easy ^^ –'
      '– Ready to translate? –'
      '– Good translations ;) –'
      '– Wordreference is your friend!! –'
      '– Be sure to follow NF EN 15038:2006 –'
      '– Make users happy! –'
    ]

    @$('h2').html randTitle[Math.floor(Math.random() * (randTitle.length + 1))]

  saveTranslations: ->
    fileContent = (require 'templates/Translate/File/Coffee') 
      translator: 'Jeremy Trufier <jeremy@trufier.com>'
      translations: translationsCollection.toJSON()
      projectId: 'com.storific.pro'
      file: 'app.js'
      hash: ''
    
    writeFile = (file)->
      alert 'Unable to write file' unless file.write fileContent

    return writeFile(ST.misc.currentTranslationFile) if ST.misc.currentTranslationFile

    Titanium.UI.getCurrentWindow().openSaveAsDialog (filesPath)-> 
        ST.misc.currentTranslationFile = Titanium.Filesystem.getFile(filesPath[0])
        writeFile()
      , 
      title: "Save translation file..."
      multiple: false
      types: ['coffee','js','json','yml']
      defaultFile: 'en.coffee'
      
  openTranslations: ->
    Titanium.UI.getCurrentWindow().openFileChooserDialog (filesPath)=>
      ST.misc.currentTranslationFile = Titanium.Filesystem.getFile(filesPath[0])
      translationsCollection.resetFromCoffee  ST.misc.currentTranslationFile.read()

  scanFile: ->
    Titanium.UI.getCurrentWindow().openFileChooserDialog (filesPath)=>
      ST.misc.currentScannedFile = Titanium.Filesystem.getFile(filesPath[0])
      translationsCollection.scan ST.misc.currentScannedFile.read()
      @displayItems()

module.exports = TranslatePageView