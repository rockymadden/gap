root = exports ? this

unless root._gap? then root._gap = []

class Gap
	subscribers: []

	constructor: (previous, subscribers) ->
		if @isArray(subscribers) then @subscribe(subscriber) for subscriber in subscribers
		if @isArray(previous) then @push(previous)

	isArray: (args) -> args? && {}.toString.call(args) is "[object Array]" && args.length > 0

	publish: (commandArray) -> subscriber.listen(commandArray) for subscriber in @subscribers

	push: (args) -> if @isArray(args)
		if @isArray(args[0]) then @push(i) for i in args
		else
			if args[0].indexOf("_gap") is 0 then @publish(args)
			else oot._gaq.push(args)

	subscribe: (subscriber) -> @subscribers.push(subscriber)

class GapReadTracker
	listen: (commandArray) ->
		if commandArray.length is 2 && commandArray[0] is "_gapTrackRead" && typeof commandArray[1] is "number"
			if root._gapReadTrackerInterval? then root.clearInterval(root._gapReadTrackerInterval)

			root._seconds = 0
			root._gapReadTrackerInterval = root.setInterval(
				fn = () -> 
					root._gap.push(["_trackEvent", "read", (root._seconds += commandArray[1]).toString()])
					fn
				, commandArray[1] * 1000
			)

(() ->
	ga = document.createElement "script"
	ga.async = true
	ga.type = "text/javascript"
	ga.src = if root.location.protocol is "https:" then "https://ssl" else "http://www" + ".google-analytics.com/ga.js"
	ga.onload = ga.onreadystatechange = () -> 
		root._gapReadTracker = new GapReadTracker()
		root._gap = new Gap(root._gap, [root._gapReadTracker])

	s = document.getElementsByTagName("script")[0]
	s.parentNode.insertBefore(ga, s)
)()

