(function() {
  var listener, root;

  root = window;

  listener = null;

  module('globals');

  test('_gap should be available', 1, function() {
    return ok(root._gap != null);
  });

  test('_gaq should be available', 1, function() {
    return ok(root._gaq != null);
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
    ok(root._gap.bounced != null);
    return equal(root._gap.bounced, false);
  });

  test('cookied property should be available and false', 2, function() {
    ok(root._gap.cookied != null);
    return equal(root._gap.cookied, false);
  });

  test('history property should be available', 1, function() {
    return ok(root._gap.history != null);
  });

  test('subscribers property should be available', 1, function() {
    return ok(root._gap.subscribers != null);
  });

  test('variables property should be available', 1, function() {
    return ok(root._gap.variables != null);
  });

  test('subscribe method should add subscriber', 2, function() {
    root._gap.subscribers = [];
    equal(root._gap.subscribers.length, 0);
    root._gap.subscribe(listener);
    return equal(root._gap.subscribers.length, 1);
  });

  test('publish method should send message to subscribers', 2, function() {
    root._gap.subscribers = [];
    root._gap.subscribe(listener);
    equal(root._gap.subscribers[0].listened, false);
    root._gap.publish(['commandArray']);
    return equal(root._gap.subscribers[0].listened, true);
  });

  test('push method should not throw', 1, function() {
    root._gap.push('commandArray');
    return ok(true);
  });

}).call(this);
