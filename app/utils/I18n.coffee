class I18n 

  constructor: ->
    @locale = 'en'
    @translations = []

    window.tr = @tr

    code = @getLanguageCode()

    pf = [
      code.language + '-' + code.region
      code.language + '-' + code.region.toUpperCase()
      code.language + '_' + code.region
      code.language + '_' + code.region.toUpperCase()
      code.language
      code.language.toUpperCase()
      code.region
      code.region.toUpperCase()
      @locale
    ]

    while pf.length and not @translations.length
      try @translations = require('locales/'+pf.shift()) catch e

    @

  getLanguageCode: ->
    lang = (window.navigator.userLanguage || window.navigator.language || 'en').toLowerCase().match(/(\w\w)[-_]?(\w\w)?/)
    { language: lang[1], region: lang[2] || lang[1] }

  # i18n
  # How is it working ?
  #
  # tr(string, arg1, arg2, ...)
  # 
  # Inside the first argument, to write some arguments the format is:
  # {0} -> write arguments 1
  # {1} -> write arguments 2
  # ...
  # {0s} -> translator help: type, can be: s(tring), i(nteger), f(loat), d(ate)
  # {0#Date field} -> Comment for the translator
  # {0i#Number} -> guess !
  tr: (s)=>
    t = @translations[s] = [].concat(@translations[s] || [])

    a = arguments
    i = 0    
    while i < t.length
      s = if typeof t[i] is "function" then t[i].apply(this, a) else t[i]
      i++
    s.replace /{(\d+)\w?(#.*?)?}/g, (n, c) ->
      a[c]  if a[c = parseInt(c) + 1]

module.exports = new I18n