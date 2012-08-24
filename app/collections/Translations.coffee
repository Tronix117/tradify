STATES = [Constants.Translation.STATE_NEW, Constants.Translation.STATE_MISSING, Constants.Translation.STATE_PENDING, Constants.Translation.STATE_DONE]
FLAGS = [Constants.Translation.FLAG_A, Constants.Translation.FLAG_B, Constants.Translation.FLAG_C]

class TranslationsCollection extends BaseCollection
  model: require 'models/Translation'

  scan: (content, options = {})->
    reg = /\Wtr\(? *["']((?:[^("|')\\]|\\.)*)["']/g
    items = []
    newItems = []
    while item = reg.exec content
      @add raw: item[1] unless @getByRaw item[1]
      model = @getByRaw item[1]
      items.push model
      newItems.push model

    @updateStates items, newItems

  resetFromCoffee: (content, options = {})->
    @reset []
    
    reg = /\s\s(".*"):\s(.*)\s(#\d*)?/g
    while item = reg.exec content
      item[2] = JSON.parse(item[2])
      item[3] = if item[3] then parseInt(item[3].substr(1)) else 0

      @add
        raw: JSON.parse item[1]
        translation: if item[2] then [item[2]] else []
        state: _.binGetNumber item[3], STATES
        flag: _.binGetNumber item[3], FLAGS, 4

  getByRaw: (raw) ->
    for item in @models
      return item if raw == item.get 'raw'
    null

  updateStates: (withoutItems, newItems)->
    oldModels = _.without.apply(this, _.union([@models], newItems))
    for model in oldModels
      model.set 'state', Constants.Translation.STATE_PENDING unless Constants.Translation.STATE_DONE = model.get 'state'

    missingModels = _.without.apply(this, _.union([@models], withoutItems))
    for model in missingModels
      model.set 'state', Constants.Translation.STATE_MISSING

module.exports = new TranslationsCollection