class BaseView extends Backbone.View

  # All managed subviews go here
  _views: null

  # Currently visible view
  _activeView: null

  # This is option that lets you specify where
  # child views will be inserted when added
  contentSelector: null

  constructor: ->
    @_views = []
    super

  # If "property" is provided, the child view will be assigned to it and
  # if "autoDestroyOnDeactivate" is true it will nullified after destruction.
  addView: (view, property = null, autoDestroyOnDeactivate = true, where = true)->
    if where
      target = where if typeof where is 'string'
      target ?= if @contentSelector? then @$(@contentSelector) else $ @el
      $(view.el).appendTo target
    @_views.push view 
    @[property] = view
    if property and autoDestroyOnDeactivate
      view.bind 'deactivate', view.destroy, view
      view.bind 'destroy', =>
        @removeView view
        if @[property] is view then @[property] = null

  setActiveView: (view)->
    # Checking that we are activating valid view
    if (_.indexOf @_views, view) is -1
      throw new Error 'You are trying to activate view that isn\'t a subview'
    
    # There's no point in reactivation
    return unless view isnt @_activeView

    # If it's the first view then we don't want changing animation
    # even if one is provided by the user
    @_setActiveViewImmediate view
    
    @_activeView = view
  
  getActiveView: -> @_activeView

  _setActiveViewImmediate: (view)->
    @trigger 'beforeactivechange', @_activeView, view
    # Hiding previous view with notifications
    if @_activeView?
      @_activeView.trigger 'beforedeactivate', @_activeView, view
      @_activeView.hide()
      @_activeView.trigger 'deactivate', @_activeView, view

    # Showing new one
    view.trigger 'beforeactivate', @_activeView, view
    view.show()
    view.trigger 'activate', @_activeView, view
    @trigger 'activechange', @_activeView, view
  
  removeView: (view)->
    index = _.indexOf @_views, view
    if index isnt -1
      if not @_destroying then @_views.splice index, 1
      view.remove()
  
  views: -> @_views
  
  destroy: ->
    @_destroying = true
    for view in @_views
      view.destroy()
      view = null
    @remove()
    @trigger 'destroy', @
    @unbind()

  hide: ->
    $(@el).hide()

  show: ->
    $(@el).show()

  # Don't overload this function in subclasses - use doRender instead
  render: ->
    @trigger 'beforerender', @
    @doRender.apply @, arguments
    @trigger 'afterrender', @
    
module.exports = BaseView