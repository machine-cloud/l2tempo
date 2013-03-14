
###
Module dependencies.
###
express = require("express")
routes = require("./routes")
http = require("http")
path = require("path")
logplex = require('./logplex_parser')
app = express()
app.configure ->
  app.set "port", process.env.PORT or 3000
  app.use express.favicon()
  app.use express.logger("dev")
  app.use express.methodOverride()
  app.use app.router
  app.use express.bodyParser()
  app.use logplex()
###
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  app.use express.static(path.join(__dirname, "public"))
###

app.configure "development", ->
  app.use express.errorHandler()

app.post "/logs", routes.log_drain

http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")
