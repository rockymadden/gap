root = exports ? this

class Gap
	subscribers: []

	constructor: (previous, subscribers) ->
		@isArray(subscribers) && @subscribe(subscriber) for subscriber in subscribers
		@isArray(previous) && @push(previous)

	isArray: (args) -> args? && {}.toString.call(args) is '[object Array]' && args.length > 0

	publish: (commandArray) -> subscriber.listen(commandArray) for subscriber in @subscribers

	push: (commandArray) ->
		if @isArray(commandArray) && @isArray(commandArray[0]) then @push(i) for i in commandArray
		else if	@isArray(commandArray)
			if commandArray[0].indexOf('_gap') is 0 then @publish(commandArray)
			else
				root._gaq.push(commandArray)
				_gapDebug? && _gapDebug && root.console? && root.console.log('Pushed: ' + commandArray)

	subscribe: (subscriber) -> @subscribers.push(subscriber)

class GapReadTracker
	listen: (commandArray) ->
		if commandArray.length is 2 && commandArray[0] is '_gapTrackReads' && typeof commandArray[1] is 'number'
			root._gapSeconds = 0
			root.setInterval(
				fn = () -> 
					root._gap.push(['_trackEvent', 'gapRead', (root._gapSeconds += commandArray[1]).toString()])
					fn
				, commandArray[1] * 1000
			)

class GapLinkClickTracker
	listen: (commandArray) ->
		if commandArray.length is 1 && commandArray[0] is '_gapTrackLinkClicks'
			root.document.getElementsByTagName('body')[0].onmousedown = (event) ->
				target = event.target || event.srcElement

				if target? && (target.nodeName is 'A' || target.nodeName is 'BUTTON')
					text = target.innerText || target.textContent
					href = target.href || ''

					root._gap.push(['_trackEvent', 'gapLinkClick', text.replace(/^\s+|\s+$/g, '') + ' (' + href + ')'])

unless root._gap? then root._gap = []
unless root._gaq? then root._gaq = []

(() ->
	ga = document.createElement 'script'
	ga.async = true
	ga.type = 'text/javascript'
	ga.src = if root.location.protocol is 'https:' then 'https://ssl' else 'http://www' + '.google-analytics.com/ga.js'
	ga.onload = ga.onreadystatechange = () -> 
		root._gapReadTracker = new GapReadTracker()
		root._gap = new Gap(root._gap, [
			new GapReadTracker(),
			new GapLinkClickTracker()
		])

	s = document.getElementsByTagName('script')[0]
	s.parentNode.insertBefore(ga, s)
)()

