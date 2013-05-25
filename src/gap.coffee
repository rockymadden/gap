root = exports ? this

class GapUtil
	constructor: () ->

	@isCommandArray: (args) -> args? && {}.toString.call(args) is '[object Array]' && args.length > 0

	@hasCookie: (name) -> root.document.cookie.indexOf(name) >= 0

class Gap
	history: []
	subscribers: []
	variables: {}

	constructor: (previous, subscribers) ->
		GapUtil.isCommandArray(subscribers) && @subscribe(subscriber) for subscriber in subscribers
		GapUtil.isCommandArray(previous) && @push(previous)

	publish: (commandArray) -> subscriber.listen(commandArray, this) for subscriber in @subscribers

	push: (commandArray) ->
		if GapUtil.isCommandArray(commandArray) && GapUtil.isCommandArray(commandArray[0])
			@push(i) for i in commandArray
		else if	GapUtil.isCommandArray(commandArray)
			if commandArray[0].indexOf('_gap') is 0 then @publish(commandArray)
			else
				root._gaq.push(commandArray)

				if root._gapDebug? && root._gapDebug && root.console?
					@history.push(commandArray)
					root.console.log('Pushed: ' + commandArray)

	subscribe: (subscriber) -> @subscribers.push(subscriber)

class GapBounceTracker
	constructor: (hasSessionCookie) -> @hasSessionCookie = hasSessionCookie

	listen: (commandArray, gap) ->
		if commandArray.length is 2 &&
		commandArray[0] is '_gapTrackBounce' &&
		typeof commandArray[1] is 'number' &&
		not @hasSessionCookie

			root.setTimeout(
				(() -> root._gap.push(['_trackEvent', 'gapBounce', commandArray[1].toString()]))
				, commandArray[1] * 1000
			)

class GapReadTracker
	constructor: () ->

	listen: (commandArray, gap) ->
		if commandArray.length is 3 &&
		commandArray[0] is '_gapTrackReads' &&
		typeof commandArray[1] is 'number' &&
		typeof commandArray[2] is 'number'

			gap.variables['gapReadTrackerSeconds'] = 0
			gap.variables['gapReadTrackerSecondsMax'] = commandArray[1] * commandArray[2]
			gap.variables['gapReadTrackerInterval'] = root.setInterval(
				fn = () ->
					if root._gap.variables['gapReadTrackerSeconds'] < root._gap.variables['gapReadTrackerSecondsMax']
						root._gap.push([
							'_trackEvent',
							'gapRead',
							(root._gap.variables['gapReadTrackerSeconds'] += commandArray[1]).toString()
						])
						fn
					else clearInterval(root._gap.variables['gapReadTrackerInterval'])
				, commandArray[1] * 1000
			)

class GapLinkClickTracker
	constructor: () ->

	listen: (commandArray, gap) ->
		if commandArray.length is 1 &&
		commandArray[0] is '_gapTrackLinkClicks'

			root.document.getElementsByTagName('body')[0].onmousedown = (event) ->
				target = event.target || event.srcElement

				if target? && (target.nodeName is 'A' || target.nodeName is 'BUTTON')
					text = target.innerText || target.textContent
					href = target.href || ''

					root._gap.push(['_trackEvent', 'gapLinkClick', text.replace(/^\s+|\s+$/g, '') + ' (' + href + ')'])

unless root._gap? then root._gap = []
unless root._gaq? then root._gaq = []

(() ->
	hc = GapUtil.hasCookie("__utmb")
	ga = root.document.createElement 'script'
	ga.async = true
	ga.type = 'text/javascript'
	ga.src = if root.location.protocol is 'https:' then 'https://ssl' else 'http://www' + '.google-analytics.com/ga.js'
	ga.onload = ga.onreadystatechange = () -> 
		root._gapReadTracker = new GapReadTracker()
		root._gap = new Gap(root._gap, [
			new GapBounceTracker(hc),
			new GapReadTracker(),
			new GapLinkClickTracker()
		])

	s = root.document.getElementsByTagName('script')[0]
	s.parentNode.insertBefore(ga, s)
)()

