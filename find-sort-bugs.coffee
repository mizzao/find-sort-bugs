@Logs = new Meteor.Collection("logs")

if Meteor.isClient
  Deps.autorun ->
    Session.get("blahValue")
    Session.get("blahValue2")
    console.log "subscribing"
    Meteor.subscribe("logs", 10)
    Meteor.setTimeout ->
      Session.set("blahValue", "blah")
      Meteor.setTimeout ->
        Session.set("blahValue2", "blah")
      , 300
    , 300

if Meteor.isServer

  if Logs.find().count() is 0
    timestamp = Date.now()
    Logs.insert({timestamp: timestamp + i*1000, value: i}) for i in [1..100]

  Meteor.publish "logs", (limit) ->
    opts =
      sort: {timestamp: -1}
      limit: limit

    return Logs.find({}, opts)
