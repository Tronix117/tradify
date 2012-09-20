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
    @$('.translate-item').remove()
    
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
    writeFile = (file, ext)->
      fileContent = (require 'templates/Translate/File/' + ext[0].toUpperCase() + ext.substr(1).toLowerCase()) 
        translator: 'Jeremy Trufier <jeremy@trufier.com>'
        translations: translationsCollection.toJSON(ext)
        projectId: 'com.storific.pro'
        file: 'app.js'
        hash: ''
      window.d=fileContent
      alert 'Unable to write file' unless file.write fileContent # String.asciiDecode(fileContent, ST.misc.currentTranslationFileEncoding)

    return writeFile(ST.misc.currentTranslationFile, ST.misc.currentTranslationFileExt) if ST.misc.currentTranslationFile

    Titanium.UI.getCurrentWindow().openSaveAsDialog (filesPath)-> 
        ST.misc.currentTranslationFile = Titanium.Filesystem.getFile(filesPath[0])
        ST.misc.currentTranslationFileExt = (filesPath[0].match /\.(.*)$/)[1]

        writeFile(ST.misc.currentTranslationFile, ST.misc.currentTranslationFileExt)
      , 
      title: "Save translation file..."
      multiple: false
      types: ['coffee','js','json','yml']
      defaultFile: 'en.coffee'
      
  openTranslations: ->
    # Fix because the toString doesn't work correctly on every files
    readContent = (content)->
      window.c = content
      bytes = []
      i = 0
      bytes.push content.byteAt i++ while i < content.length
      ST.misc.currentTranslationFileEncoding = String.detectEncoding(bytes)
      String.asciiEncode String.binaryToAscii(bytes), ST.misc.currentTranslationFileEncoding

    Titanium.UI.getCurrentWindow().openFileChooserDialog (filesPath)=>
      ST.misc.currentTranslationFileExt = (filesPath[0].match /\.([^\.]+)$/)[1]
      ST.misc.currentTranslationFile = Titanium.Filesystem.getFile(filesPath[0])
      console.log ST.misc.currentTranslationFileExt
      alert tr 'Filetype not supported' unless translationsCollection[method = ('resetFrom' + ST.misc.currentTranslationFileExt[0].toUpperCase() + ST.misc.currentTranslationFileExt.substr(1).toLowerCase())]
      translationsCollection[method].call translationsCollection, readContent ST.misc.currentTranslationFile.read()
      @displayItems()

  scanFile: ->
    Titanium.UI.getCurrentWindow().openFileChooserDialog (filesPath)=>
      ST.misc.currentScannedFile = Titanium.Filesystem.getFile(filesPath[0])
      translationsCollection.scan ST.misc.currentScannedFile.read()
      @displayItems()

module.exports = TranslatePageView