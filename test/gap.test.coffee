test '_gap global variable is available', 1, () ->
	ok _gap?

test '_gaq global variable is available', 1, () ->
	ok _gaq?

test '_gapTrackReads', () ->
	stop()

	setTimeout(
		(() ->
			reads = (i for i in _gap.history when i.length > 1 and i[1] is 'gapRead')
			ok reads.length >= 2
			start()
		),
		2000
	)

test '_gapTrackLinkClicks', 1, () ->
	# TODO: Has issues with dynamic dispatch and triggering mousedown events on links.
	ok true
