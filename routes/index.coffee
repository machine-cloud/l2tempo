
#
# * GET home page.
#
exports.index = (req, res) ->
  res.render "index",
    title: "Express"

TempoDBClient = require("tempodb").TempoDBClient
tempodb = new TempoDBClient(process.env.TEMPODB_API_KEY, process.env.TEMPODB_API_SECRET)


exports.log_drain = (req, res) ->
  ts = new Date()
  data = []
  for readings in req.body
    if readings.device_id
      data.push
        key: "battery:" + readings.device_id
        v: parseFloat(readings.battery)
      data.push
        key: "temp:" + readings.device_id
        v: parseFloat(readings.temp)

  if data[0]
    tempodb.write_bulk ts, data, (result) ->
      out = result.response
      console.log(result.body) unless out == '200'
      console.log "tempodb=" + out
  else
    console.log("no-readings=true")
  res.send('OK')
