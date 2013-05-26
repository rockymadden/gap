listener = null

module('globals')

test '_gap should be available', 1, () ->
	ok(_gap?)

test '_gaq should be available', 1, () ->
	ok(_gaq?)

module('Gap', 
	setup: () ->
		listener = new (class Litsener
			constructor: () -> @listened = false
			listen: (commandArray, gap) -> @listened = true
		)()
)

test 'bounced property should be available and false', 2, () ->
	ok(_gap.bounced?)
	equal(_gap.bounced, false)

test 'cookied property should be available and false', 2, () ->
	ok(_gap.cookied?)
	equal(_gap.cookied, false)

test 'history property should be available', 1, () ->
	ok(_gap.history?)

test 'subscribers property should be available', 1, () ->
	ok(_gap.subscribers?)

test 'variables property should be available', 1, () ->
	ok(_gap.variables?)

test 'subscribe method should add subscriber', 2, () ->
	_gap.subscribers = []
	
	equal(_gap.subscribers.length, 0)

	_gap.subscribe(listener)

	equal(_gap.subscribers.length, 1)

test 'publish method should send message to subscribers', 2, () ->
	_gap.subscribers = []
	_gap.subscribe(listener)

	equal(_gap.subscribers[0].listened, false)

	_gap.publish(['commandArray'])

	equal(_gap.subscribers[0].listened, true)

test 'push method should not throw', 1, () ->
	_gap.push('commandArray')
	ok(true)
