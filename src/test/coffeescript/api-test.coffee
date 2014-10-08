root = window
tracker = null

module('Api',
  setup: -> tracker = new (class Tracker
    constructor: -> @listened = false
    listen: (command) -> @listened = true
  )()
)

test 'state', 1, -> ok(root._gap.state?)

test 'trackers', 1, -> ok(root._gap.trackers?)

test 'subscribe', 2, ->
  root._gap.trackers = {}
  equal(Object.keys(root._gap.trackers).length, 0)
  root._gap.subscribe('tracker', tracker)
  equal(Object.keys(root._gap.trackers).length, 1)

test 'publish', 2, ->
  root._gap.subscribers = {}
  root._gap.subscribe('tracker', tracker)
  equal(root._gap.trackers.tracker.listened, false)
  root._gap.publish(['commandArray'])
  equal(root._gap.trackers.tracker.listened, true)

test 'push', 1, ->
  root._gap.push(['command'])
  ok(true)
