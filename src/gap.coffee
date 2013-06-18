class Gap
	constructor: (previous, subscribers, bounced, cookied, debug) ->
		@bounced = bounced
		@cookied = cookied
		@debug = debug
		@history = []
		@subscribers = []
		@variables = {}

		GapUtil.isCommandArray(subscribers) and @subscribe(subscriber) for subscriber in subscribers
		GapUtil.isCommandArray(previous) and @push(previous)

	debug: (commandArray) ->
		@history.push(commandArray)

		if root.console? then root.console.log('Pushed: ' + commandArray.toString())
		else root.alert('Pushed: ' + commandArray.toString())

	publish: (commandArray) -> subscriber.listen(commandArray, this) for subscriber in @subscribers

	push: (commandArray) ->
		if GapUtil.isCommandArray(commandArray)
			if GapUtil.isCommandArray(commandArray[0]) then @push(i) for i in commandArray
			else
				if commandArray[0].indexOf('_gap') is 0 then @publish(commandArray)
				else
					root._gaq.push(commandArray)
					if debug? then @debug(commandArray)

	subscribe: (subscriber) -> @subscribers.push(subscriber)

