root = window

unless root._gap? then root._gap = []
unless root._gaq? then root._gaq = []

(->
	hasCookie = Dom.hasCookie('__utmb')

	ga = root.document.createElement 'script'
	ga.async = true
	ga.type = 'text/javascript'
	ga.src = if root.location.protocol is 'https:' then 'https://ssl' else 'http://www' + '.google-analytics.com/ga.js'
	ga.onload = ga.onreadystatechange = ->
		root._gap = new Gap(root._gap, root._gaq, {cookied: hasCookie, debugging: Func.truthy(root._gapDebug)})

	s = root.document.getElementsByTagName('script')[0]
	s.parentNode.insertBefore(ga, s)
)()
