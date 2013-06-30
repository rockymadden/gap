root = window
tracker = null

module('Gap',
	setup: -> tracker = new (class Tracker
		constructor: -> @listened = false
		listen: (command) -> @listened = true
	)()
)

test 'state property should be available', 1, -> ok(root._gap.state?)

test 'trackers property should be available', 1, -> ok(root._gap.trackers?)

test 'subscribe method should add tracker', 2, ->
	root._gap.trackers = {}
	equal(Object.keys(root._gap.trackers).length, 0)
	root._gap.subscribe('tracker', tracker)
	equal(Object.keys(root._gap.trackers).length, 1)

test 'publish method should send message to trackers', 2, ->
	root._gap.subscribers = {}
	root._gap.subscribe('tracker', tracker)
	equal(root._gap.trackers.tracker.listened, false)
	root._gap.publish(['commandArray'])
	equal(root._gap.trackers.tracker.listened, true)

test 'push method should not throw', 1, ->
	root._gap.push(['command'])
	ok(true)
