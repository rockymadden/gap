root = window

module('Func')

test 'existy', 8, ->
	equal(Gap.Func.existy(undefined), false)
	equal(Gap.Func.existy(null), false)
	equal(Gap.Func.existy(''), true)
	equal(Gap.Func.existy(0), true)
	equal(Gap.Func.existy(false), true)
	equal(Gap.Func.existy(true), true)
	equal(Gap.Func.existy({}), true)
	equal(Gap.Func.existy([]), true)

test 'truthy', 8, ->
	equal(Gap.Func.truthy(undefined), false)
	equal(Gap.Func.truthy(null), false)
	equal(Gap.Func.truthy(''), true)
	equal(Gap.Func.truthy(0), true)
	equal(Gap.Func.truthy(false), false)
	equal(Gap.Func.truthy(true), true)
	equal(Gap.Func.truthy({}), true)
	equal(Gap.Func.truthy([]), true)

test 'lengthy', 10, ->
	equal(Gap.Func.lengthy(undefined), false)
	equal(Gap.Func.lengthy(null), false)
	equal(Gap.Func.lengthy(''), false)
	equal(Gap.Func.lengthy('a'), true)
	equal(Gap.Func.lengthy(0), false)
	equal(Gap.Func.lengthy(false), false)
	equal(Gap.Func.lengthy(true), false)
	equal(Gap.Func.lengthy({}), false)
	equal(Gap.Func.lengthy([]), false)
	equal(Gap.Func.lengthy(['a']), true)

