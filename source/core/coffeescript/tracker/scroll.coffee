class GapScrollTracker
	constructor: (gap) -> @gap = gap

	listen: (commandArray) -> switch commandArray[0]
		when '_gapTrackBounceViaScroll'
			if commandArray.length is 2 and typeof commandArray[1] is 'number' and not @gap.cookied and not @gap.bounced
				@gap.variables.bounceViaScrollPercentage = commandArray[1]
				@gap.variables.bounceViaScrollFunction = ->
					if not root._gap.bounced and GapUtil.scrolled() >= root._gap.variables.bounceViaScrollPercentage
						root._gap.bounced = true
						root._gap.push([
							'_trackEvent'
							'gapBounceViaScroll'
							root._gap.variables.bounceViaScrollPercentage.toString()
						])

				GapUtil.append(root, 'onscroll', (event) ->
					if root._gap.variables.bounceViaScrollTimeout? then clearTimeout(root._gap.variables.bounceViaScrollTimeout)
					root._gap.variables.bounceViaScrollTimeout = setTimeout(root._gap.variables.bounceViaScrollFunction, 100)
				)
		when '_gapTrackMaxScroll'
			if commandArray.length is 2 and typeof commandArray[1] is 'number'
				@gap.variables.maxScrollPercentage = commandArray[1]
				@gap.variables.maxScrollFunction = ->
					percentage = GapUtil.scrolled()

					if percentage >= root._gap.variables.maxScrollPercentage and
					(not root._gap.variables.maxScrolledPercentage? or percentage > root._gap.variables.maxScrolledPercentage)

						root._gap.variables.maxScrolledPercentage = percentage

				GapUtil.append(root, 'onscroll', (event) ->
					if root._gap.variables.maxScrollTimeout? then clearTimeout(root._gap.variables.maxScrollTimeout)
					root._gap.variables.maxScrollTimeout = setTimeout(root._gap.variables.maxScrollFunction, 100)
				)
				GapUtil.append(root, 'onunload', (event) -> if root._gap.variables.maxScrolledPercentage?
					root._gap.push([
						'_trackEvent'
						'gapMaxScroll'
						root._gap.variables.maxScrolledPercentage.toString()
					])
				)
