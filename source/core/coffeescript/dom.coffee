class Dom
	@append: (element, event, fn) ->
		if not Func.existy(element) or typeof element isnt 'object' then @error('Expected valid element.')
		if not Func.existy(event) or typeof event isnt 'string' then @error('Expected valid event.')
		if not Func.existy(fn) or typeof fn isnt 'function' then @error('Expected valid fn.')

		pfn = element[event]

		if not Func.existy(pfn) then element[event] = fn
		else element[event] = (e) ->
			pfn(e)
			fn(e)

	@debug: (message) ->
		if not Func.lengthy(message) or typeof message isnt 'string' then @error('Expected valid debug message.')

		m = ['DEBUG:', message].join(' ')
		if Func.existy(root.console) then root.console.log(m) else root.alert(n)

	@documentHeight: -> Math.max(
		root.document.body.scrollHeight or 0,
		root.document.documentElement.scrollHeight or 0,
		root.document.body.offsetHeight or 0,
		root.document.documentElement.offsetHeight or 0,
		root.document.body.clientHeight or 0,
		root.document.documentElement.clientHeight or 0
	)

	@hasCookie: (name) ->
		if not Func.lengthy(name) or typeof name isnt 'string' then @error('Expected valid name.')

		root.document.cookie.indexOf(name) >= 0

	@error: (message) ->
		if not Func.lengthy(message) or typeof message isnt 'string' then message = ('Expected valid error message.')

		throw new Error(message)

	@scrolledPercent: -> Math.floor(((@windowScroll() + @windowHeight()) / @documentHeight()) * 100)

	@windowHeight: ->
		root.innerHeight or root.document.documentElement.clientHeight or root.document.body.clientHeight or 0

	@windowScroll: ->
		root.pageYOffset or root.document.body.scrollTop or root.document.documentElement.scrollTop or 0
