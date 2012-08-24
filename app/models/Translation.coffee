class TranslationModel extends BaseModel

  defaults:
    raw: ''
    value: null
    help: []
    translation: []
    state: Constants.Translation.STATE_NEW
    flag: 0
  
  initialize: ->
    @set 'value', @get('raw').replace(/{(\d+)\w?(#.*)?}/g, (n, c) -> '{' + parseInt(c) + '}')
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
    bin = _.binEnable 0, @flag + 4 if @flag > 0
    bin = _.binEnable bin, @state
    bin

  toJSON: ->
    json = _.clone @attributes
    json.binary = @getBinary()
    json

module.exports = TranslationModel