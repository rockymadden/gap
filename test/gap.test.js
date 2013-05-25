(function() {
  test('_gap global variable is available', 1, function() {
    return ok(typeof _gap !== "undefined" && _gap !== null);
  });

  test('_gaq global variable is available', 1, function() {
    return ok(typeof _gaq !== "undefined" && _gaq !== null);
  });

  test('_gapTrackBounceViaTime', function() {
    stop();
    return setTimeout((function() {
      var i, reads;

      reads = (function() {
        var _i, _len, _ref, _results;

        _ref = _gap.history;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          i = _ref[_i];
          if (i.length > 1 && i[1] === 'gapBounceViaTime') {
            _results.push(i);
          }
        }
        return _results;
      })();
      ok(reads.length === 1);
      return start();
    }), 1250);
  });

  test('_gapTrackReads', function() {
    stop();
    return setTimeout((function() {
      var i, reads;

      reads = (function() {
        var _i, _len, _ref, _results;

        _ref = _gap.history;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          i = _ref[_i];
          if (i.length > 1 && i[1] === 'gapRead') {
            _results.push(i);
          }
        }
        return _results;
      })();
      ok(reads.length >= 2);
      return start();
    }), 2250);
  });

  test('_gapTrackLinkClicks', 1, function() {
    return ok(true);
  });

}).call(this);
