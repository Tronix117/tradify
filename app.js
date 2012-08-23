var fs = require('fs')

fs.readFile('/Users/jeremyt/Dropbox/Storific/Developer/storific_pro/build/web/js/app.js', function(err,data){
  if(err) {
    console.error("Could not open file: %s", err)
    process.exit(1)
  }
  console.log(findStringsToTranslate(data.toString()))
})

var findStringsToTranslate = function(v) {
  r = /\Wtr\( *["']((?:[^("|')\\]|\\.)*)["']/g
  t = []
  while(m = r.exec(v)){
    t.push(m[1])
  }
  return t
}

