# L2X
#### (where x = TempoDB)

Look, ma! I'm sending logplex logs to TempoDB!

Coffeescript HTTP LogPlex bouncer.  This one sends logs to TempoDB.
But it parses those logs like a champ.
You should probably steal most of that code.


## Install

    > npm install
    > redis-server
    > foreman start web
    > ./test.sh


## ENV

    > heroku addons:add tempodb

or set

    TEMPODB_API_HOST
    TEMPODB_API_KEY
    TEMPODB_API_PORT
    TEMPODB_API_SECRET
    TEMPODB_API_SECURE

## `logplex`
### at `logplex.coffee`
  an express middleware that pulls key=value pairs from logplex
  built from `byo`

## `byo`
### at `byo.coffee`
  an express middleware that lets you Bring Your Own bodyParser
