# Adding stuff to underscore
module.exports = 
  binDisable: (bin, numbers)->
    numbers = [].concat numbers
    for n in numbers
      bin ^= Math.pow(2,n) if bin & Math.pow(2,n)
    bin

  binEnable: (bin, numbers)->
    numbers = [].concat numbers
    for n in numbers
      bin |= Math.pow(2,n)
    bin

  binIsEnabled: (bin, number)->
    bin & Math.pow(2,n)

  binGetNumber: (bin, numbers, offset = 0)->
    for k in numbers
      return k - offset if Math.pow(2, k) & bin
    0