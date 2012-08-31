String.utf8Decode = (bytes) ->
  string = ''
  i = c = 0
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

String.utf8Encode = (text) ->
  bytes = []
  
  n = 0
  while n < text.length
    c = text.charCodeAt n

    if c < 128
      bytes.push c
    else if (c > 127) && (c < 2048)
      bytes.push (c >> 6) | 192
      bytes.push (c & 63) | 128
    else
      bytes.push (c >> 12) | 224
      bytes.push ((c >> 6) & 63) | 128
      bytes.push (c & 63) | 128

    n++

  bytes

String.utf16Encode = (text, bigEndian) ->
  text = text.replace /\r\n/g, '\n'
  bytes= []

  n = 0

  while n < text.length
    c = text.charCodeAt n

    bytes.push c >> 8 if bigEndian
    bytes.push c & 63
    bytes.push c >> 8 unless bigEndian
  
  bom = if bigEndian then [0xFE, 0xFF] else [0xFF, 0xFE]
  bytes = bom.merge bytes

String.utf16Decode = (bytes, bigEndian) ->
  string = ''
  
  i = 0
  o1 = if bigEndian then 0 else 1
  o2 = if bigEndian then 1 else 0
  
  while i < bytes.length
    b1 = bytes[i+o1]
    b2 = bytes[i+o2]
    string += String.fromCharCode((b1<<8)+b2)
    i+=2
    
  string

String.binaryToAscii = (bytes) ->
  n = 0
  ascii = ''
  while n < bytes.length
    ascii += String.fromCharCode bytes[n]
  ascii

String.asciiToBinary = (ascii) ->
  ascii = ascii.replace /\r\n/g, '\n'
  n = 0
  bytes = []
  while n < ascii.length
    bytes += ascii.charCodeAt n
  bytes

String.detectEncoding = (bytes) ->
  return 'utf7'      if bytes[0] == 0x2B && bytes[1] == 0x2F && bytes[2] == 0x76 && ([0x38, 0x39, 0x2B, 0x2F].indexOf(bytes[3]) != -1 || ( bytes[3] == 0x38 && bytes[4] == 0x2D))
  return 'utf32le'   if bytes[0] == 0xFF && bytes[1] == 0xFE && bytes[2] == 0x00 && bytes[3] == 0x00
  return 'utf32be'   if bytes[0] == 0x00 && bytes[1] == 0x00 && bytes[2] == 0xFE && bytes[3] == 0xFF
  return 'utfebcdic' if bytes[0] == 0xDD && bytes[1] == 0x73 && bytes[2] == 0x66 && bytes[3] == 0x73
  return 'scsu'      if bytes[0] == 0x0E && bytes[1] == 0xFE && bytes[2] == 0xFF
  return 'bocu1'     if bytes[0] == 0xFB && bytes[1] == 0xEE && bytes[2] == 0x28
  return 'utf8'      if bytes[0] == 0xEF && bytes[1] == 0xBB && bytes[2] == 0xBF
  return 'utf16le'   if bytes[0] == 0xFF && bytes[1] == 0xFE
  return 'utf16be'   if bytes[0] == 0xFE && bytes[1] == 0xFF
  'undefined'

String.asciiDecode = (text, encoding = 'utf8') ->
  bytes = String.asciiToBinary text
  switch encoding
    when 'utf16le' then return String.utf16Encode(bytes, false)
    when 'utf16be' then return String.utf16Encode(bytes, true)
    else return String.utf8Encode(bytes)

String.asciiEncode = (ascii, encoding = null) ->
  bytes = String.asciiToBinary ascii
  encoding = String.detectEncoding(bytes) unless encoding

  switch encoding
    when 'utf7' 
      i = if bytes[3] == 0x38 && bytes[4] == 0x2D then 5 else 4
    when 'utf32le', 'utf32be', 'utfebcdic'  then i = 4
    when 'scsu', 'bocu1', 'utf8'            then i = 3
    when 'utf16le', 'utf16be'               then i = 2
    else                                         i = 0

  bytes.shift() while 0 < i--

  switch encoding
    when 'utf16le' then return String.utf16Decode(bytes, false)
    when 'utf16be' then return String.utf16Decode(bytes, true)
    else return String.utf8Decode(bytes)