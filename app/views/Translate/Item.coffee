class TranslateItemView extends BaseView
  template: require 'templates/Translate/Item'

  events:
    'keypress .translation': 'updateTranslation'

  initialize: -> 
    @render()

  updateTranslation: ->
    @model.translation = [@$('.translation').val()]

module.exports = TranslateItemView