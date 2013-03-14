# L2X
#### (where x = TempoDB)

Look, ma! I'm sending logplex logs to TempoDB!

Coffeescript HTTP LogPlex bouncer.  This one sends logs to TempoDB.
But it parses those logs like a champ.
You should probably steal most of that code.

## `logplex`
### at `logplex.coffee`
  an express middleware that pulls key=value pairs from logplex
  built from `byo`

## `byo`
### at `byo.coffee`
  an express middleware that lets you Bring Your Own bodyParser
