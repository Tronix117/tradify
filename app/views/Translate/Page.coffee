itemView = require 'views/Translate/Item'
menuBar = require 'templates/Translate/MenuBar'

class TranslatePageView extends BaseView
  template: require 'templates/Translate/Page'
  id: 'translate-page'
  el: '#viewport'

  events:
    'click .action-save': 'saveTranslations'

  initialize: ->
    @initModel()
    @render()
    @enhance()

  enhance: ->
    $(@el).prepend menuBar()

    for model in ST.collections.Translations.models
      new itemView
        model: model
        el: $('<div class="translate-item"></div>').appendTo('#translate-page')

  initModel: ->
    ST.collections.Translations = translationsCollection = new BaseCollection

    for toTranslate in ST.misc.scannedTranslations
      model = new BaseModel
        raw: toTranslate
        value: toTranslate.replace(/{(\d+)\w?(#.*)?}/g, (n, c) -> '{' + parseInt(c) + '}')
        help: @findTranslationHelp(toTranslate)
        translation: []
        state: Math.pow(2,Constants.Translation.STATE_NEW) #&& 'new' || Math.pow(2,Constants.Translation.STATE_MISSING) && 'missing' || Math.pow(2,Constants.Translation.STATE_MISSING) && 'done'
        flag: 0 #Math.pow(2,Constants.Translation.STATE_FLAG_A) && 1 || Math.pow(2,Constants.Translation.STATE_FLAG_B) && 2 || Math.pow(2,Constants.Translation.STATE_FLAG_C) && 3 || 0
      translationsCollection.add model

    @model.set 'collection', translationsCollection


  findTranslationHelp: (s)->
    help = []
    r=/{(\d+)(\w?)#?(.*)?}/g
    while args = r.exec(s)
      help.push
        number: args[1]
        type: Constants.Translation.HELP_TYPE[args[2]] || ''
        comment: args[3] || ''
    help

  saveTranslations: ->
    cb = (filesPath)->
      console.log arguments
      fileContent = (require 'templates/Translate/File/Coffee') 
        translator: 'Jeremy Trufier <jeremy@trufier.com>'
        translations: ST.collections.Translations.toJSON()
        projectId: 'com.storific.pro'
        file: 'app.js'
        hash: ''
      alert 'Unable to write file' unless Titanium.Filesystem.getFile(filesPath[0]).write fileContent

    Titanium.UI.getCurrentWindow().openSaveAsDialog cb, 
      title: "Save translation file..."
      multiple: false
      types: ['coffee','js','json','yml']
      defaultFile: 'en.coffee'
      


module.exports = TranslatePageView