String.utf8DecodeFromBytes = (bytes) ->
  string = ""
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