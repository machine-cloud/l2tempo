
#
# * GET home page.
#
exports.index = (req, res) ->
  res.render "index",
    title: "Express"

librato = (args) -> console.log(args)

exports.log_drain = (req, res) ->
  measurements = {}
  units = {}
  has_values = {}
  console.log(req.headers)
  console.log(req.body)
  res.send('OK')
###
  log.start "logs", (logger) ->
    try
      for entry in JSON.parse(req.body.payload).events
        if pairs = entry.message.match(/([a-zA-Z0-9\_\-\.]+)=?(([a-zA-Z0-9\.\-\_\.]+)|("([^\"]+)"))?/g)
          attrs = {}
          for pair in pairs
            parts = pair.split("=")
            key   = parts.shift()
            value = parts.join("=")
            value = value.substring(1, value.length-1) if value[0] is '"'
            attrs[key] = value
          if attrs.measure
            name = attrs.measure
            name = "#{attrs.ns}.#{name}" if attrs.ns
            source = attrs.source || ""
            value = attrs.value || attrs.val
            measurements[name] ||= {}
            measurements[name][source] ||= []
            int_value = parseInt(value || "1")
            int_value = 0 if isNaN(int_value)
            measurements[name][source].push int_value
            units[name] ||= attrs.units
            has_values[name] = true if value

      gauges = []
      for name, source_values of measurements
        for source, values of source_values
          sorted = values.sort()
          sum    = sorted.reduce (ax, n) -> ax+n
          if has_values[name]
            gauges.push create_gauge("#{name}.mean",   source, (sum / sorted.length).toFixed(3),        units[name], "average")
            gauges.push create_gauge("#{name}.perc95", source, sorted[Math.ceil(0.95*sorted.length)-1], units[name], "average")
            gauges.push create_gauge("#{name}.count",  source, sorted.length,                           "count",     "sum")
          else
            gauges.push create_gauge("#{name}.count", source, sorted.length, "count", "sum")

      librato.post "/metrics", gauges:gauges, (err, result) ->
        if err
          logger.error err
          res.send "error", 422
        else
          logger.success()
          for gauge in gauges
            log.success metric:gauge.name, value:gauge.value, source:gauge.source
          res.send "ok"
    catch err
      logger.error err
      res.send "error", 422

###
