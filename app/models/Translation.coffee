class TranslationModel extends BaseModel

  defaults:
    raw: ''
    value: null
    help: []
    translation: []
    state: Constants.Translation.STATE_NEW
    flag: 0
    comment: ''
  
  initialize: ->
    @set 'value', @get('raw').replace(/{(\d+)\w?(#.*)?}/g, (n, c) -> '{' + parseInt(c) + '}') if not @.get 'value'
    @set 'help', @findTranslationHelp(@get('raw'))

  findTranslationHelp: (s)->
    help = []
    r=/{(\d+)(\w?)#?(.*)?}/g
    while args = r.exec(s)
      help.push
        number: args[1]
        type: Constants.Translation.HELP_TYPE[args[2]] || ''
        comment: args[3] || ''
    help

  getBinary: ->
    bin = _.binEnable 0, @.get 'state'
    bin = _.binEnable bin, @.get('flag') + 4 if 0 < @.get 'flag'
    bin

  toJSON: (type)->
    json = _.clone @attributes

    if type == "strings"
      json.translation[0] = json.translation[0].replace /{(\d+)}/g, -> '%' + (parseInt(arguments[1]) + 1) + '$@'

    json.binary = @getBinary()
    json

module.exports = TranslationModel