utf8Decode = (bytes) ->
  string = ''
  i = 0
  while i < bytes.length
    c = bytes[i]

    if c < 128
      string += String.fromCharCode c
      i += 1
    else if (c > 191) && (c < 224)
      string += String.fromCharCode(((c & 31) << 6) | (bytes[i+1] & 63))
      i += 2
    else
      string += String.fromCharCode(((c & 15) << 12) | ((bytes[i+1] & 63) << 6) | (bytes[i+2] & 63))
      i += 3
  string

utf16Decode = (bytes, bigEndian) ->
  string = ''
  i = 0
  o1 = 1
  o2 = 0

  if bigEndian
    o1 = 0
    o2 = 1
  
  while i < bytes.length
    b1 = bytes[i+o1]
    b2 = bytes[i+o2]
    w1 = (b1<<8)+b2
    if b1 < 0xD8 || b1 >= 0xE0
      string += String.fromCharCode(w1)
    else
      i+=2
      b3 = bytes[i+o1]
      b4 = bytes[i+o2]
      w2 = (b3<<8)+b4
      string += String.fromCharCode(w1, w2)
    i+=2
    
  string

String.utfDecodeFromBytes = (bytes) ->
  string = ''
  i = c = 0

  if bytes[0] == 0xFF && bytes[1] == 0xFE
    bom = 'utf16le'
    i=2
  else if bytes[0] == 0xFE && bytes[1] == 0xFF
    bom = 'utf16be'
    i=2
  else if bytes[0] == 0xFF && bytes[1] == 0xFE && bytes[2] == 0x00 && bytes[3] == 0x00
    bom = 'utf32le'
    i=4
  else if bytes[0] == 0x00 && bytes[1] == 0x00 && bytes[2] == 0xFE && bytes[3] == 0xFF
    bom = 'utf32be'
    i=4
  else if bytes[0] == 0x0E && bytes[1] == 0xFE && bytes[2] == 0xFF
    bom = 'scsu'
    i=3
  else if bytes[0] == 0x2B && bytes[1] == 0x2F && bytes[2] == 0x76 && ([0x38, 0x39, 0x2B, 0x2F].indexOf(bytes[3]) != -1 || ( bytes[3] == 0x38 && bytes[4] == 0x2D))
    bom = 'utf7'
    i= if bytes[3] == 0x38 && bytes[4] == 0x2D then 5 else 4
  else if bytes[0] == 0xDD && bytes[1] == 0x73 && bytes[2] == 0x66 && bytes[3] == 0x73
    bom = 'utfebcdic'
    i=4
  else if bytes[0] == 0xFB && bytes[1] == 0xEE && bytes[2] == 0x28
    bom = 'bocu1'
    i=3
  else if bytes[0] == 0xEF && bytes[1] == 0xBB && bytes[2] == 0xBF
    bom = 'utf8'
    i=3
  else
    bom = 'utf8'

  bytes.shift() while 0 < i--
  
  switch bom
    when 'utf16le' then return utf16Decode(bytes, false)
    when 'utf16be' then return utf16Decode(bytes, true)
    else return utf8Decode(bytes)


String.utf8EncodeToBytes = (text) ->
  text = text.replace /\r\n/g, '\n'
  bytes = []
  
  n = 0
  while n < text.length
    c = text.charCodeAt n

    if c < 128
      bytes.push String.fromCharCode c
    else if (c > 127) && (c < 2048)
      bytes.push String.fromCharCode((c >> 6) | 192)
      bytes.push String.fromCharCode((c & 63) | 128)
    else
      bytes.push String.fromCharCode((c >> 12) | 224)
      bytes.push String.fromCharCode(((c >> 6) & 63) | 128)
      bytes.push String.fromCharCode((c & 63) | 128)

    n++

  bytes