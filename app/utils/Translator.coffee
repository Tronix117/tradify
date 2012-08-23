module.exports =
  findStringsToTranslate: (v)->
    r = /\Wtr\(? *["']((?:[^("|')\\]|\\.)*)["']/g
    t = []
    while m = r.exec v
      t.push m[1]
    t