I18n = {}

I18n.locale = 'en'
I18n.fallback_locale = 'en'

I18n.globalize = -> window.tr = I18n.tr
I18n.load = -> window._Translations = requireSafe('locales/' + I18n.locale) || requireSafe('locales/' + I18n.fallback_locale) || []

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
I18n.tr = (s)->
  I18n.load() if !window._Translations

  t = _Translations[s] = [].concat(_Translations[s] || [])

  a = arguments
  i = 0    
  while i < t.length
    s = if typeof t[i] is "function" then t[i].apply(this, a) else t[i]
    i++
  s.replace /{(\d+)\w?(#.*)?}/g, (n, c) ->
    a[c]  if a[c = parseInt(c) + 1]

module.exports = I18n