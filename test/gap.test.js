(function() {
  test('_gap global variable should be available', 1, function() {
    return ok(typeof _gap !== "undefined" && _gap !== null);
  });

  test('_gaq global variable should be available', 1, function() {
    return ok(typeof _gaq !== "undefined" && _gaq !== null);
  });

}).call(this);
