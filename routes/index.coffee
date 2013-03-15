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

TempoDBClient = require("tempodb").TempoDBClient
tempodb = new TempoDBClient(process.env.TEMPODB_API_KEY, process.env.TEMPODB_API_SECRET)

exports.log_drain = (req, res) ->
  ts = new Date()
  data = []
  for line in req.body
    if line.readings
      readings = line
      console.log(line)

  if data[0]
    tempodb.write_bulk ts, data, (result) ->
      out = result.response
      console.log(result.body) unless out == '200'
      console.log "tempodb=" + out
  else
    console.log("no-readings=true")
  res.send('OK')

      ###=
      data.push
        key: "battery:" + readings.device_id
        v: parseFloat(readings.battery)
      data.push
        key: "temp:" + readings.device_id
        v: parseFloat(readings.temp)
        ###
