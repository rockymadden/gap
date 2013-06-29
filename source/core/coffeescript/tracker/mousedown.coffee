class GapMousedownTracker
	constructor: (gap) -> @gap = gap

	listen: (commandArray) -> switch commandArray[0]
		when '_gapTrackLinkClicks'
			GapUtil.append(root.document.getElementsByTagName('body')[0], 'onmousedown', (event) ->
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

