root = window

module('Func')

test 'existy', 8, ->
	equal(gap.Func.existy(undefined), false)
	equal(gap.Func.existy(null), false)
	equal(gap.Func.existy(''), true)
	equal(gap.Func.existy(0), true)
	equal(gap.Func.existy(false), true)
	equal(gap.Func.existy(true), true)
	equal(gap.Func.existy({}), true)
	equal(gap.Func.existy([]), true)

test 'truthy', 8, ->
	equal(gap.Func.truthy(undefined), false)
	equal(gap.Func.truthy(null), false)
	equal(gap.Func.truthy(''), true)
	equal(gap.Func.truthy(0), true)
	equal(gap.Func.truthy(false), false)
	equal(gap.Func.truthy(true), true)
	equal(gap.Func.truthy({}), true)
	equal(gap.Func.truthy([]), true)

test 'lengthy', 10, ->
	equal(gap.Func.lengthy(undefined), false)
	equal(gap.Func.lengthy(null), false)
	equal(gap.Func.lengthy(''), false)
	equal(gap.Func.lengthy('a'), true)
	equal(gap.Func.lengthy(0), false)
	equal(gap.Func.lengthy(false), false)
	equal(gap.Func.lengthy(true), false)
	equal(gap.Func.lengthy({}), false)
	equal(gap.Func.lengthy([]), false)
	equal(gap.Func.lengthy(['a']), true)

