class GapMousedownTracker
	constructor: (gap) -> @gap = gap

	appendOnMousedown: (fn) ->
		omd = root.document.getElementsByTagName('body')[0].onmousedown

		if not omd? then root.document.getElementsByTagName('body')[0].onmousedown = fn
		else root.document.getElementsByTagName('body')[0].onmousedown = (event) ->
			omd(event)
			fn(event)

	listen: (commandArray) -> switch commandArray[0]
		when '_gapTrackLinkClicks'
			@appendOnMousedown((event) ->
				target = event.target or event.srcElement

				if target? and (target.nodeName is 'A' or target.nodeName is 'BUTTON')
					text = target.innerText or target.textContent
					href = target.href or ''

					root._gap.push([
						'_trackEvent',
						'gapLinkClick',
						text.replace(/^\s+|\s+$/g, '') + ' (' + href + ')'
					])
			)

