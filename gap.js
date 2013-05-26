(function() {
  var Gap, GapMousedownTracker, GapScrollTracker, GapTimeTracker, GapUtil, root;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  Gap = (function() {
    Gap.prototype.history = [];

    Gap.prototype.subscribers = [];

    Gap.prototype.variables = {};

    function Gap(previous, subscribers, cookied) {
      var subscriber, _i, _len;

      this.bounced = false;
      this.cookied = cookied;
      for (_i = 0, _len = subscribers.length; _i < _len; _i++) {
        subscriber = subscribers[_i];
        GapUtil.isCommandArray(subscribers) && this.subscribe(subscriber);
      }
      GapUtil.isCommandArray(previous) && this.push(previous);
    }

    Gap.prototype.publish = function(commandArray) {
      var subscriber, _i, _len, _ref, _results;

      _ref = this.subscribers;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        subscriber = _ref[_i];
        _results.push(subscriber.listen(commandArray, this));
      }
      return _results;
    };

    Gap.prototype.push = function(commandArray) {
      var i, _i, _len, _results;

      if (GapUtil.isCommandArray(commandArray) && GapUtil.isCommandArray(commandArray[0])) {
        _results = [];
        for (_i = 0, _len = commandArray.length; _i < _len; _i++) {
          i = commandArray[_i];
          _results.push(this.push(i));
        }
        return _results;
      } else if (GapUtil.isCommandArray(commandArray)) {
        if (commandArray[0].indexOf('_gap') === 0) {
          return this.publish(commandArray);
        } else {
          root._gaq.push(commandArray);
          if ((root._gapDebug != null) && root._gapDebug && (root.console != null)) {
            this.history.push(commandArray);
            return root.console.log('Pushed: ' + commandArray);
          }
        }
      }
    };

    Gap.prototype.subscribe = function(subscriber) {
      return this.subscribers.push(subscriber);
    };

    return Gap;

  })();

  GapTimeTracker = (function() {
    function GapTimeTracker() {}

    GapTimeTracker.prototype.listen = function(commandArray, gap) {
      var fn;

      switch (commandArray[0]) {
        case '_gapTrackBounceViaTime':
          if (commandArray.length === 2 && typeof commandArray[1] === 'number' && !gap.cookied && !gap.bounced) {
            return gap.variables['bounceViaTimeTimeout'] = root.setTimeout((function() {
              if (!root._gap.bounced) {
                root._gap.bounced = true;
                return root._gap.push(['_trackEvent', 'gapBounceViaTime', commandArray[1].toString()]);
              }
            }), commandArray[1] * 1000);
          }
          break;
        case '_gapTrackReads':
          if (commandArray.length === 3 && typeof commandArray[1] === 'number' && typeof commandArray[2] === 'number') {
            gap.variables['readsSeconds'] = 0;
            gap.variables['readsSecondsMax'] = commandArray[1] * commandArray[2];
            return gap.variables['readsInterval'] = root.setInterval(fn = (function() {
              if (root._gap.variables['readsSeconds'] < root._gap.variables['readsSecondsMax']) {
                root._gap.push(['_trackEvent', 'gapRead', (root._gap.variables['readsSeconds'] += commandArray[1]).toString()]);
                return fn;
              } else {
                return clearInterval(root._gap.variables['readsInterval']);
              }
            }), commandArray[1] * 1000);
          }
      }
    };

    return GapTimeTracker;

  })();

  GapMousedownTracker = (function() {
    function GapMousedownTracker() {}

    GapMousedownTracker.prototype.append = function(f) {
      var omd;

      omd = root.document.getElementsByTagName('body')[0].onmousedown;
      if (omd == null) {
        return root.document.getElementsByTagName('body')[0].onmousedown = f;
      } else {
        return root.document.getElementsByTagName('body')[0].onmousedown = function(event) {
          omd(event);
          return f(event);
        };
      }
    };

    GapMousedownTracker.prototype.listen = function(commandArray, gap) {
      switch (commandArray[0]) {
        case '_gapTrackLinkClicks':
          return this.append(function(event) {
            var href, target, text;

            target = event.target || event.srcElement;
            if ((target != null) && (target.nodeName === 'A' || target.nodeName === 'BUTTON')) {
              text = target.innerText || target.textContent;
              href = target.href || '';
              return root._gap.push(['_trackEvent', 'gapLinkClick', text.replace(/^\s+|\s+$/g, '') + ' (' + href + ')']);
            }
          });
      }
    };

    return GapMousedownTracker;

  })();

  GapScrollTracker = (function() {
    function GapScrollTracker() {}

    GapScrollTracker.prototype.append = function(f) {
      var os;

      os = window.onscroll;
      if (os == null) {
        return window.onscroll = f;
      } else {
        return window.onscroll = function(event) {
          os(event);
          return f(event);
        };
      }
    };

    GapScrollTracker.prototype.listen = function(commandArray, gap) {
      switch (commandArray[0]) {
        case '_gapTrackBounceViaScroll':
          if (commandArray.length === 2 && typeof commandArray[1] === 'number' && !gap.cookied && !gap.bounced) {
            gap.variables['bounceViaScrollPercentage'] = commandArray[1];
            return this.append(function(event) {
              if (!gap.bounced && ((GapUtil.windowScroll() + GapUtil.windowHeight()) / GapUtil.documentHeight()) * 100 >= root._gap.variables['bounceViaScrollPercentage']) {
                root._gap.bounced = true;
                return root._gap.push(['_trackEvent', 'gapBounceViaScroll', root._gap.variables['bounceViaScrollPercentage']]);
              }
            });
          }
      }
    };

    return GapScrollTracker;

  })();

  GapUtil = (function() {
    function GapUtil() {}

    GapUtil.documentHeight = function() {
      return Math.max(root.document.body.scrollHeight || 0, root.document.documentElement.scrollHeight || 0, root.document.body.offsetHeight || 0, root.document.documentElement.offsetHeight || 0, root.document.body.clientHeight || 0, root.document.documentElement.clientHeight || 0);
    };

    GapUtil.isCommandArray = function(args) {
      return (args != null) && {}.toString.call(args) === '[object Array]' && args.length > 0;
    };

    GapUtil.hasCookie = function(name) {
      return root.document.cookie.indexOf(name) >= 0;
    };

    GapUtil.windowHeight = function() {
      return root.window.innerHeight || root.document.documentElement.clientHeight || root.document.body.clientHeight || 0;
    };

    GapUtil.windowScroll = function() {
      return root.window.pageYOffset || root.document.body.scrollTop || root.document.documentElement.scrollTop || 0;
    };

    return GapUtil;

  })();

  if (root._gap == null) {
    root._gap = [];
  }

  if (root._gaq == null) {
    root._gaq = [];
  }

  (function() {
    var ga, hasGaSessionCookie, s;

    hasGaSessionCookie = GapUtil.hasCookie("__utmb");
    ga = root.document.createElement('script');
    ga.async = true;
    ga.type = 'text/javascript';
    ga.src = root.location.protocol === 'https:' ? 'https://ssl' : 'http://www' + '.google-analytics.com/ga.js';
    ga.onload = ga.onreadystatechange = function() {
      return root._gap = new Gap(root._gap, [new GapTimeTracker(), new GapMousedownTracker(), new GapScrollTracker()], hasGaSessionCookie);
    };
    s = root.document.getElementsByTagName('script')[0];
    return s.parentNode.insertBefore(ga, s);
  })();

}).call(this);
