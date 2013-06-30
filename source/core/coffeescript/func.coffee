class Func
	@existy: (a) -> a?

	@lengthy: (a) -> @truthy(a) and a.hasOwnProperty('length') and a.length > 0

	@truthy: (a) -> @existy(a) and (a isnt false)

