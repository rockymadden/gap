root = window

module('Core')

test '_gap should be available', 1, -> ok(root._gap?)

test '_gaq should be available', 1, -> ok(root._gaq?)
