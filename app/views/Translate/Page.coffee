class TranslateView extends BaseView
  template: require 'templates/Translate/Page'
  id: 'translate-page'
  el: '#viewport'

  initialize: ->
    @initModel()
    @render()

  initModel: ->
    ST.collections.Translations = translationsCollection = new BaseCollection

    for toTranslate in ST.misc.scannedTranslations
      translationsCollection.add 
        raw: toTranslate
        help: @findTranslationHelp(toTranslate)
        translation: []

      @model.set 'collection', translationsCollection


  findTranslationHelp: (s)->
    help = []
    r=/{(\d+)(\w?)#?(.*)?}/g
    while args = r.exec(s)
      help.push
        number: args[1]
        type: {i: 'number', f: 'decimal', d: 'date', s: 'text'}[args[2]] || ''
        comment: args[3] || ''
    help

module.exports = TranslateView