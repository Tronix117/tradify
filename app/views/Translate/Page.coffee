class TranslateView extends BaseView
  template: require 'templates/Translate/Page'
  id: 'translate-page'
  el: '#viewport'

  initialize: ->
    @model.set 'translations', ST.misc.scannedTranslations
    @render()

module.exports = TranslateView