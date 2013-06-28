class GapScrollTracker
	constructor: (gap) -> @gap = gap

	appendOnScroll: (fn) ->
		os = root.onscroll

		if not os? then root.onscroll = fn
		else root.onscroll = (event) ->
			os(event)
			fn(event)

	appendOnUnload: (fn) ->
		ou = root.onunload

		if not ou? then root.onunload = fn
		else root.onunload = (event) ->
			ou(event)
			fn(event)

	listen: (commandArray) -> switch commandArray[0]
		when '_gapTrackBounceViaScroll'
			if commandArray.length is 2 and typeof commandArray[1] is 'number' and not @gap.cookied and not @gap.bounced
				@gap.variables.bounceViaScrollPercentage = commandArray[1]
				@gap.variables.bounceViaScrollFunction = ->
					percentage = Math.floor(((GapUtil.windowScroll() + GapUtil.windowHeight()) / GapUtil.documentHeight()) * 100)

					if not root._gap.bounced and percentage >= root._gap.variables.bounceViaScrollPercentage
						root._gap.bounced = true
						root._gap.push([
							'_trackEvent'
							'gapBounceViaScroll'
							root._gap.variables.bounceViaScrollPercentage
						])

				@appendOnScroll((event) ->
					if root._gap.variables.bounceViaScrollTimeout? then clearTimeout(root._gap.variables.bounceViaScrollTimeout)
					root._gap.variables.bounceViaScrollTimeout = setTimeout(root._gap.variables.bounceViaScrollFunction, 100)
				)
		when '_gapTrackMaxScroll'
			if commandArray.length is 2 and typeof commandArray[1] is 'number'
				@gap.variables.maxScrollPercentage = commandArray[1]
				@gap.variables.maxScrollFunction = ->
					percentage = Math.floor(((GapUtil.windowScroll() + GapUtil.windowHeight()) / GapUtil.documentHeight()) * 100)

					if percentage >= root._gap.variables.maxScrollPercentage and
					(not root._gap.variables.maxScrolledPercentage? or percentage > root._gap.variables.maxScrolledPercentage)

						root._gap.variables.maxScrolledPercentage = percentage

				@appendOnScroll((event) ->
					if root._gap.variables.maxScrollTimeout? then clearTimeout(root._gap.variables.maxScrollTimeout)
					root._gap.variables.maxScrollTimeout = setTimeout(root._gap.variables.maxScrollFunction, 100)
				)
				@appendOnUnload((event) -> if root._gap.variables.maxScrolledPercentage?
					root._gap.push([
						'_trackEvent'
						'gapMaxScroll'
						root._gap.variables.maxScrolledPercentage
					])
				)

