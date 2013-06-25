class GapUtil
	@documentHeight: -> Math.max(
		root.document.body.scrollHeight or 0,
		root.document.documentElement.scrollHeight or 0,
		root.document.body.offsetHeight or 0,
		root.document.documentElement.offsetHeight or 0,
		root.document.body.clientHeight or 0,
		root.document.documentElement.clientHeight or 0
	)

	@hasCookie: (name) -> root.document.cookie.indexOf(name) >= 0

	@isCommandArray: (potential) ->
		potential? and {}.toString.call(potential) is '[object Array]' and potential.length > 0

	@windowHeight: ->
		root.innerHeight or root.document.documentElement.clientHeight or root.document.body.clientHeight or 0

	@windowScroll: ->
		root.pageYOffset or root.document.body.scrollTop or root.document.documentElement.scrollTop or 0

