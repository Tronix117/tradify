class BaseView extends Backbone.View

  constructor: ->
    @model = new (require 'models/Base')
    super

  render: ->
    $(@el).html @template @model.toJSON()
    @

module.exports = BaseView