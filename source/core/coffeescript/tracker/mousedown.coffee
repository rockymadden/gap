class MousedownTracker
	constructor: (api, state) ->
		if not Func.existy(api) or typeof api isnt 'object' then Dom.error('Expected api to be an object.')
		if not Func.existy(state) or typeof state isnt 'object' then Dom.error('Expected state to be an object.')

		@_api = api
		@state = state

	listen: (commandArray) -> switch commandArray[0]
		when '_gapTrackLinkClicks'
			Dom.append(root.document.getElementsByTagName('body')[0], 'onmousedown', (event) ->
				target = event.target or event.srcElement

				if Func.existy(target) and (target.nodeName is 'A' or target.nodeName is 'BUTTON')
					gap = root._gap
					href = target.href or ''
					text = target.innerText or target.textContent

					gap.push([
						'_trackEvent'
						'gapLinkClick'
						text.replace(/^\s+|\s+$/g, '') + ' (' + href + ')'
					])
			)
