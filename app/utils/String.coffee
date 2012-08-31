String.utf8DecodeFromBytes = (bytes) ->
  string = ''
  i = c = 0

  if bytes[0] == 255 && bytes[1] == 254
    bom = 'utf16le'
    i=2
  else if bytes[0] == 254 && bytes[1] == 255
    bom = 'utf16be'
    i=2
  else if bytes[0] == 239 && bytes[1] == 187 && bytes[2] == 191
    bom = 'utf8'
    i=3
  else if bytes[0] == 255 && bytes[1] == 254 && bytes[2] == 0 && bytes[3] == 0
    bom = 'utf32le'
    i=4
  else if bytes[0] == 0 && bytes[1] == 0 && bytes[2] == 254 && bytes[3] == 255
    bom = 'utf32be'
    i=4
  else if bytes[0] == 14 && bytes[1] == 254 && bytes[2] == 255
    bom = 'scsu'
    i=3
  else if bytes[0] == 43 && bytes[1] == 47 && bytes[2] == 118 && ([56, 57, 43, 47].indexOf(bytes[3]) != -1 || ( bytes[3] == 56 && bytes[4] == 45))
    bom = 'utf7'
    i= if bytes[3] == 56 && bytes[4] == 45 then 5 else 4
  else if bytes[0] == 221 && bytes[1] == 115 && bytes[2] == 102 && bytes[3] == 115
    bom = 'utfebcdic'
    i=4
  else if bytes[0] == 251 && bytes[1] == 238 && bytes[2] == 40
    bom = 'bocu1'
    i=3
  else
    bom = null

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