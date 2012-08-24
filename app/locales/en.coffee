###
Translator: Jeremy Trufier <jeremy@trufier.com>
Company: 
ProjectId: com.storific.translator
File: app.js
Hashsum: ee44b7d1844577df0c3233f7c0ee5007
###

$=
  pluralize: (i, t0, t1, to)-> (s)-> 
    n = parseInt(arguments[i+1])
    return if n == 0 then t0 else if n == 1 then t1 else to

  genderize: (i, tm, tf, to)-> (s)-> 
    sex = arguments[i+1]
    return if sex == 'male' then tm else if sex == 'female' then tf else to


T= 
  "Hello {0#first_name}": null
  "There is {0i} fish and {1}": $.pluralize(0, "There is no fish and {1}", "There is 1 fish {1}", "There are {0} fishes")
  "You are a man": $.genderize(0, "You are a man", "You are a woman")
  "– Nothing to translate. You should try opening an existing translation file, or scanning some sourcecode ;) –": "– Rien à traduire. Vous devriez essayer d'ouvrir un fichier de traduction existant, ou scanner du code source ;) –"

module.exports = T