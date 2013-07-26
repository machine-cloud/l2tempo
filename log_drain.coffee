#
# * send readings to TempoDB when readings=XXXX is true
#
# take all the readings reported in the logs and treat
# the log event as the tempo event. so any lag from the
# device to the log line to the request here will show.
#
# we can fix this by having the device send the time of
# its log, but then we may still need to aggregate for
# performance
#
# this implementation is considered "Good Enough"

through = require('through')
TempoDBClient = require("tempodb").TempoDBClient
tempodb = new TempoDBClient(process.env.TEMPODB_API_KEY, process.env.TEMPODB_API_SECRET)

exports.log_drain = (req, res) ->
  ts = new Date()
  data = []

  add_lines_to_data = (line) ->
    if line.readings
      device = line.device_id

      data.push
        key: "device:ThermoStat.battery.id:#{device}.series"
        v: parseFloat(line.battery)
      data.push
        key: "device:ThermoStat.temp.id:#{device}.series"
        v: parseFloat(line.temp)

  end = () ->
    if data[0]
      tempodb.write_bulk ts, data, (result) ->
        out = result.response
        console.log(result.body) unless out == '200'
        console.log "tempodb=" + out
    else
      console.log("no-readings=true")

  req.body.pipe(through(add_lines_to_data, end)) if req.body
  res.send('OK')
