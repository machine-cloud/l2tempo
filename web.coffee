
###
Module dependencies.
###
express = require("express")
http = require("http")
path = require("path")
routes  = require("./routes")
logplex = require("./logplex")
app = express()

app.configure ->
  app.set "port", process.env.PORT or 3000
  app.use express.favicon()
  app.use express.logger("dev")
  app.use express.methodOverride()
  # LogPlex body parser
  app.use logplex()
  app.use express.bodyParser()
  app.use app.router
###
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  app.use express.static(path.join(__dirname, "public"))
###

app.configure "development", ->
  app.use express.errorHandler()

# Connect Routes
app.post "/logs", routes.log_drain
app.get  "/", (req, res) -> res.send("NOTHING TO SEE HERE")

# Listen for Requests
http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")
