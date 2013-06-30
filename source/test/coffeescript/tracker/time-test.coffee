root = window
tracker = null

module('GapTimeTracker',
	setup: -> if not root._gap.trackers.tracker?
		tracker = new (class Tracker
			constructor: -> @history = []
			listen: (command) -> @history.push(command)
		)()

		root._gap.subscribe('tracker', tracker)
)

test '_gapTrackBounceViaTime should push a gapBounceViaTime event', ->
	stop()

	setTimeout(
		(->
			reads = (i for i in root._gap.trackers.tracker.history when i.length > 1 and i[1] is 'gapBounceViaTime')
			ok(reads.length == 1)
			start()
		),
		1250
	)

test '_gapTrackReads should push gapRead events', ->
	stop()

	setTimeout(
		(->
			reads = (i for i in root._gap.trackers.tracker.history when i.length > 1 and i[1] is 'gapRead')
			ok(reads.length >= 2)
			start()
		),
		2250
	)
