(function() {
  var listener;

  listener = null;

  module('globals');

  test('_gap should be available', 1, function() {
    return ok(typeof _gap !== "undefined" && _gap !== null);
  });

  test('_gaq should be available', 1, function() {
    return ok(typeof _gaq !== "undefined" && _gaq !== null);
  });

  module('Gap', {
    setup: function() {
      var Litsener;

      return listener = new (Litsener = (function() {
        function Litsener() {
          this.listened = false;
        }

        Litsener.prototype.listen = function(commandArray, gap) {
          return this.listened = true;
        };

        return Litsener;

      })())();
    }
  });

  test('bounced property should be available and false', 2, function() {
    ok(_gap.bounced != null);
    return equal(_gap.bounced, false);
  });

  test('cookied property should be available and false', 2, function() {
    ok(_gap.cookied != null);
    return equal(_gap.cookied, false);
  });

  test('history property should be available', 1, function() {
    return ok(_gap.history != null);
  });

  test('subscribers property should be available', 1, function() {
    return ok(_gap.subscribers != null);
  });

  test('variables property should be available', 1, function() {
    return ok(_gap.variables != null);
  });

  test('subscribe method should add subscriber', 2, function() {
    _gap.subscribers = [];
    equal(_gap.subscribers.length, 0);
    _gap.subscribe(listener);
    return equal(_gap.subscribers.length, 1);
  });

  test('publish method should send message to subscribers', 2, function() {
    _gap.subscribers = [];
    _gap.subscribe(listener);
    equal(_gap.subscribers[0].listened, false);
    _gap.publish(['commandArray']);
    return equal(_gap.subscribers[0].listened, true);
  });

  test('push method should not throw', 1, function() {
    _gap.push('commandArray');
    return ok(true);
  });

}).call(this);
