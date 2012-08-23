class TranslateItemView extends BaseView
  template: require 'templates/Translate/Item'

  events:
    'keypress .translation': 'updateTranslation'
    'click .flag': 'changeFlag'

  initialize: -> 
    @render()
    $(@el).addClass 'state-' + @model.get 'state'

  updateTranslation: ->
    @model.set 'translation', [@$('.translation').val()]

  changeFlag: ->
    $flag = @$('.flag')
    @model.set 'flag', ($flag.hasClass('flag0') && 1 || $flag.hasClass('flag1') && 2 || $flag.hasClass('flag2') && 3 || 0)
    $flag.removeClass('flag0 flag1 flag2 flag3').addClass 'flag' + @model.get 'flag'

module.exports = TranslateItemView