byo     = require('./byo')

logplex = (body) ->
  lines = []
  for line in body.split("\n")
    if pairs = line.match(/([a-zA-Z0-9\_\-\.]+)=?(([a-zA-Z0-9\.\-\_\.]+)|("([^\"]+)"))?/g)
      attrs = {}
      for pair in pairs
        parts = pair.split("=")
        key   = parts.shift()
        value = parts.join("=")
        value = value.substring(1, value.length-1) if value[0] is '"'
        attrs[key] = value
      lines.push(attrs)
  lines

exports = module.exports = () ->
  byo(content_type: "application/logplex-1", parser: logplex)
