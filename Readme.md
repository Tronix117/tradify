Tradify
==========

Provides a nice interface (win, osx, linux), you can give to all your translators, along with files to translate.
It's finaly the end to translator who give you back '.doc' files, now you will directly have your localisations files in a ready to use format.

And here is the download links: [Download Tradify!](https://github.com/Tronix117/tradify/downloads)

Adapt a color code (default grey, green, red, blue) to see directly which translations need to be reviewed, or have been accepted.

You can see a [screenshot here](http://d.pr/i/VF5l)

This is not a perfect solution, I basicaly made it in one night, there is a lot of functionalities, I want to integrate in the future:

* Conditional wizard for JavaScript and CoffeeScript translation files: If the parameters is `azerty` then the translation will be `azerty` otherwise it will be `qwerty`. Or If the parameters is 1 or less the translation will be `{0} children` otherwise `{0} child`
* Name of translators
* Translations on the Cloud
* Automatic save and previous states
* Drop Titanium Desktop

Supported file formats
-------------
* `.strings` file from Cocoa and CocoaTouch framework, I18n will never be so easy for your translators
* `.coffee` files has detailled in the "Javascript and CoffeeScript translations" section bellow
* `.yml` files for the default Rails I18n

You can send me a message to request more formats ;)
I may someday have the time to answer your wishes

How to translators!
-------------

Not even sure an How to is necessary

1. Open the application (win: Tradify.exe, osx: Tradify.app or linux: Tradify)
2. Click the `Open` button, and choose a file to translate
3. Translate!! And eventualy flag the translations you are not sure or you want to review at the end using the grey circle at the left of the translation
4. Save
5. Send back the files to the technical team


Javascript or CoffeeScript translations
-------------

### I18n

I've made a nice I18n class which allow you to translate pretty everything, with every specific case you can encounter.

Here are the steps:

1. Include the I18n.js or I18n.coffee to your application: [Code is here!](https://gist.github.com/4108590)
2. Replace every untranslated sentences you have in all your code by:
* `<?=tr('text to translate')?>` with eco templates for example
* `<script>trw('text to translate')</script>` in your html code
* `var translatedText = tr('text to translate')` in your javascript code
See in the following section for more info about `tr`
3. Open Tradify, hit the button `Scan the code` and select the folder where your website/webapp is. Tradify will scan and look for `tr`, and will then display every sentences you (or your translators) need to translate
4. Save using the `Save` button, if this file hasn't been saved yet it will ask where to save it. it's basicaly in the 'locales' folder at the root of your website. You can change the folder in the I18n script
5. Send this file to your translators and enjoy !!

### More about the `tr` method 

#### Parameters

You can add parameters inside `tr`:
* `tr('There is {0} wolf(s) and {1} gobelins in front of the house', 5, 3)`
* or even `tr('There is {0} wolf(s) and {1} gobelins {2} {3}', 5, 3, tr('behind'), tr('the house'))`

Because translators are really... dumbs with computer and logic stuff, you can add some comments:
* `tr('There is {0i} wolf(s) and {1i} gobelins {2s#position like behind or in front of} {3s#name of a place}', 5, 3, tr('behind'), tr('the house'))`
* `{0i}` means an integer is expected (not yet implemented in Tradify): i=integer, s=string, f=float, d=date
* `{0#comment}` allow the translator to see this comment

#### Comments

Not yet implemented, but will be, so you can start using it:
`tr('Nothing!')` can be translated with a lot of other words, and everything depends about the context, so just write:
`tr('Nothing!@# Talking about items')`, the translator will have `Talking about items` as help for the translation

Note that if you want to escape the `@#` (don't know why you could ever have that... anyway...) just double the @: `Hey, here my @@#, and what is here is not a comment')`

### More about the translation file

Here an self-explicit exemple of a coffee translation file:
Note: For simplifying explanations, I translate from English to English 

```coffee-script
$=
  pluralize: (i, t0, t1, to)-> (s)-> 
    n = parseInt(arguments[i+1])
    return if n == 0 then t0 else if n == 1 then t1 else to

  genderize: (i, tm, tf)-> (s)-> 
    sex = arguments[i+1]
    return s.replace('{'+i+'}', sex == 'male' ? tm : tf)

T= 
  "Hello {0#first_name}": null
  "There is {0i} fish and {1}": $.pluralize(0, "There is no fish and {1}", "There is 1 fish {1}", "There are {0} fishes")
  "As a {0}, here {1} more complex exemple": [ $.pluralize(0, "As a {0}, here no more complex exemple", "As a {0}, here 1 more complex exemple", "As a {0}, here {1} more complexes exemples"), $.genderize(0, 'man', 'female') ]

module.exports = T
```

Licence
-------------

Copyright © 2012, Jeremy Trufier <jeremy@trufier.com>
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
The Software is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the Software.
Except as contained in this notice, the name of the <copyright holders> shall not be used in advertising or otherwise to promote the sale, use or other dealings in this Software without prior written authorization from the <copyright holders>.
