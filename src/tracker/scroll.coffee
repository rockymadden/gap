class GapScrollTracker
	append: (fn) ->
		os = root.onscroll

		if not os? then root.onscroll = fn
		else root.onscroll = (event) ->
			os(event)
			fn(event)

	listen: (commandArray, gap) ->
		switch commandArray[0]
			when '_gapTrackBounceViaScroll'
				if commandArray.length is 2 and
				typeof commandArray[1] is 'number' and
				not gap.cookied and
				not gap.bounced

					gap.variables['bounceViaScrollPercentage'] = commandArray[1]
					@append((event) ->
						if not gap.bounced and
						((GapUtil.windowScroll() + GapUtil.windowHeight()) / GapUtil.documentHeight()) * 100 \
						>= root._gap.variables['bounceViaScrollPercentage']

							root._gap.bounced = true
							root._gap.push([
								'_trackEvent',
								'gapBounceViaScroll',
								root._gap.variables['bounceViaScrollPercentage']
							])
					)

