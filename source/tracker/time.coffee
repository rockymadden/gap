class GapTimeTracker
	constructor: (gap) -> @gap = gap

	listen: (commandArray) ->
		switch commandArray[0]
			when '_gapTrackBounceViaTime'
				if commandArray.length is 2 and
				typeof commandArray[1] is 'number' and
				not @gap.cookied and
				not @gap.bounced
					
					@gap.variables['bounceViaTimeTimeout'] = root.setTimeout(
						(->
							if not root._gap.bounced
								root._gap.bounced = true
								root._gap.push([
									'_trackEvent',
									'gapBounceViaTime',
									commandArray[1].toString()
								])
						),
						commandArray[1] * 1000
					)
			when '_gapTrackReads'
				if commandArray.length is 3 and
				typeof commandArray[1] is 'number' and
				typeof commandArray[2] is 'number'

					@gap.variables['readsSeconds'] = 0
					@gap.variables['readsSecondsMax'] = commandArray[1] * commandArray[2]
					@gap.variables['readsInterval'] = root.setInterval(
						fn = (->
							if root._gap.variables['readsSeconds'] < root._gap.variables['readsSecondsMax']
								root._gap.push([
									'_trackEvent',
									'gapRead',
									(root._gap.variables['readsSeconds'] += commandArray[1]).toString()
								])
								fn
							else clearInterval(root._gap.variables['readsInterval'])
						),
						commandArray[1] * 1000
					)

