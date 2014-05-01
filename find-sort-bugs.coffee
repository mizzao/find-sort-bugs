@Logs = new Meteor.Collection("logs")

if Meteor.isClient
  Meteor.subscribe("logs", 10)

  Template.hello.logs = -> Logs.find({}, {sort: timestamp: -1})

  Template.hello.events =
    "click button": -> Meteor.call("insert-entry")

if Meteor.isServer
  Logs._ensureIndex({timestamp: 1})

  if Logs.find().count() is 0
    timestamp = Date.now()
    Logs.insert({timestamp: timestamp + i*1000, value: i}) for i in [1..100]

  Meteor.methods
    "insert-entry": ->
      maxLog = Logs.findOne({}, {sort: timestamp: -1})
      toInsert = {timestamp: maxLog.timestamp + 1000, value: maxLog.value + 1}
      Logs.insert(toInsert)

  Meteor.publish "logs", (limit) ->
    opts =
      sort: {timestamp: -1}
      limit: limit

    return Logs.find({}, opts)
