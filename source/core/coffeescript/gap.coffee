class Gap
	constructor: (gap, gaq, bounced, cookied, debugging) ->
		@bounced = bounced
		@cookied = cookied
		@debugging = debugging
		@gaq = gaq
		@history = []
		@subscribers = []
		@variables = {}

		@subscribe(new GapTimeTracker(@))
		@subscribe(new GapMousedownTracker(@))
		@subscribe(new GapScrollTracker(@))

		if GapUtil.isCommandArray(gap)? then @push(gap)

	debug: (commandArray) ->
		@history.push(commandArray)

		if root.console? then root.console.log('Pushed: ' + commandArray.toString())
		else root.alert('Pushed: ' + commandArray.toString())

	publish: (commandArray) -> subscriber.listen(commandArray) for subscriber in @subscribers

	push: (commandArray) -> if GapUtil.isCommandArray(commandArray)
		if GapUtil.isCommandArray(commandArray[0]) then @push(i) for i in commandArray
		else if commandArray[0].indexOf('_gap') is 0 then @publish(commandArray)
		else
			@gaq.push(commandArray)
			if @debugging? then @debug(commandArray)

	subscribe: (subscriber) -> @subscribers.push(subscriber)

