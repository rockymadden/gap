root = exports ? this

class Gap
	history: []
	subscribers: []
	variables: {}

	constructor: (previous, subscribers, cookied) ->
		@bounced = false
		@cookied = cookied
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

class GapTimeTracker
	constructor: () ->

	listen: (commandArray, gap) ->
		switch commandArray[0]
			when '_gapTrackBounceViaTime'
				if commandArray.length is 2 &&
				typeof commandArray[1] is 'number' &&
				not gap.cookied &&
				not gap.bounced

					gap.variables['bounceViaTimeTimeout'] = root.setTimeout(
						(() -> 
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
				if commandArray.length is 3 &&
				typeof commandArray[1] is 'number' &&
				typeof commandArray[2] is 'number'

					gap.variables['readsSeconds'] = 0
					gap.variables['readsSecondsMax'] = commandArray[1] * commandArray[2]
					gap.variables['readsInterval'] = root.setInterval(
						fn = (() ->
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

class GapMousedownTracker
	constructor: () ->

	# Old school for most browser support.
	append: (f) ->
		omd = root.document.getElementsByTagName('body')[0].onmousedown

		if not omd? then root.document.getElementsByTagName('body')[0].onmousedown = f
		else root.document.getElementsByTagName('body')[0].onmousedown = (event) ->
			omd(event)
			f(event)

	listen: (commandArray, gap) ->
		switch commandArray[0]
			when '_gapTrackLinkClicks'
				@append((event) ->
					target = event.target || event.srcElement

					if target? && (target.nodeName is 'A' || target.nodeName is 'BUTTON')
						text = target.innerText || target.textContent
						href = target.href || ''

						root._gap.push([
							'_trackEvent',
							'gapLinkClick',
							text.replace(/^\s+|\s+$/g, '') + ' (' + href + ')'
						])
				)

class GapScrollTracker
	constructor: () ->

	# Old school for most browser support.
	append: (f) ->
		os = window.onscroll

		if not os? then window.onscroll = f
		else window.onscroll = (event) ->
			os(event)
			f(event)

	listen: (commandArray, gap) ->
		switch commandArray[0]
			when '_gapTrackBounceViaScroll'
				if commandArray.length is 2 &&
				typeof commandArray[1] is 'number' &&
				not gap.cookied &&
				not gap.bounced

					gap.variables['bounceViaScrollPercentage'] = commandArray[1]
					@append((event) ->
						if not gap.bounced &&
						((GapUtil.windowScroll() + GapUtil.windowHeight()) / GapUtil.documentHeight()) * 100 \
						>= root._gap.variables['bounceViaScrollPercentage']

							root._gap.bounced = true
							root._gap.push([
								'_trackEvent',
								'gapBounceViaScroll',
								root._gap.variables['bounceViaScrollPercentage']
							])
					)

class GapUtil
	constructor: () ->

	@documentHeight: () -> Math.max(
		root.document.body.scrollHeight || 0,
		root.document.documentElement.scrollHeight || 0,
		root.document.body.offsetHeight || 0,
		root.document.documentElement.offsetHeight || 0,
		root.document.body.clientHeight || 0,
		root.document.documentElement.clientHeight || 0
	)

	@isCommandArray: (args) -> args? && {}.toString.call(args) is '[object Array]' && args.length > 0

	@hasCookie: (name) -> root.document.cookie.indexOf(name) >= 0

	@windowHeight: () -> 
		root.window.innerHeight || root.document.documentElement.clientHeight ||
		root.document.body.clientHeight || 0

	@windowScroll: () -> root.window.pageYOffset || root.document.body.scrollTop || root.document.documentElement.scrollTop || 0

unless root._gap? then root._gap = []
unless root._gaq? then root._gaq = []

(() ->
	hasGaSessionCookie = GapUtil.hasCookie("__utmb")

	ga = root.document.createElement 'script'
	ga.async = true
	ga.type = 'text/javascript'
	ga.src = if root.location.protocol is 'https:' then 'https://ssl' else 'http://www' + '.google-analytics.com/ga.js'
	ga.onload = ga.onreadystatechange = () -> 
		root._gap = new Gap(
			root._gap,
			[new GapTimeTracker(), new GapMousedownTracker(), new GapScrollTracker()],
			hasGaSessionCookie
		)

	s = root.document.getElementsByTagName('script')[0]
	s.parentNode.insertBefore(ga, s)
)()
