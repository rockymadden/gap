(function() {
  var root;

  root = window;

  module('Core');

  test('_gap should be available', 1, function() {
    return ok(root._gap != null);
  });

  test('_gaq should be available', 1, function() {
    return ok(root._gaq != null);
  });

}).call(this);
