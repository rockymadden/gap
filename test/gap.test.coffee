root = window
listener = null

module('globals')

test '_gap should be available', 1, -> ok(root._gap?)

test '_gaq should be available', 1, -> ok(root._gaq?)

module('Gap',
	setup: -> listener = new (class Litsener
		constructor: -> @listened = false
		listen: (commandArray, gap) -> @listened = true
	)()
)

test 'bounced property should be available and false', 2, ->
	ok(root._gap.bounced?)
	equal(root._gap.bounced, false)

test 'cookied property should be available and false', 2, ->
	ok(root._gap.cookied?)
	equal(root._gap.cookied, false)

test 'history property should be available', 1, -> ok(root._gap.history?)

test 'subscribers property should be available', 1, -> ok(root._gap.subscribers?)

test 'variables property should be available', 1, -> ok(root._gap.variables?)

test 'subscribe method should add subscriber', 2, ->
	root._gap.subscribers = []
	equal(root._gap.subscribers.length, 0)
	root._gap.subscribe(listener)
	equal(root._gap.subscribers.length, 1)

test 'publish method should send message to subscribers', 2, ->
	root._gap.subscribers = []
	root._gap.subscribe(listener)
	equal(root._gap.subscribers[0].listened, false)
	root._gap.publish(['commandArray'])
	equal(root._gap.subscribers[0].listened, true)

test 'push method should not throw', 1, ->
	root._gap.push('commandArray')
	ok(true)
