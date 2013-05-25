(function() {
  var Gap, GapBounceTracker, GapLinkClickTracker, GapReadTracker, GapUtil, root;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  GapUtil = (function() {
    function GapUtil() {}

    GapUtil.isCommandArray = function(args) {
      return (args != null) && {}.toString.call(args) === '[object Array]' && args.length > 0;
    };

    GapUtil.hasSessionCookie = function() {
      return root.document.cookie.indexOf("__utmb") >= 0;
    };

    return GapUtil;

  })();

  Gap = (function() {
    Gap.prototype.history = [];

    Gap.prototype.subscribers = [];

    Gap.prototype.variables = {};

    function Gap(previous, subscribers) {
      var subscriber, _i, _len;

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

  GapBounceTracker = (function() {
    function GapBounceTracker(hasSessionCookie) {
      this.hasSessionCookie = hasSessionCookie;
    }

    GapBounceTracker.prototype.listen = function(commandArray, gap) {
      if (commandArray.length === 2 && commandArray[0] === '_gapTrackBounce' && typeof commandArray[1] === 'number' && !this.hasSessionCookie) {
        return root.setTimeout((function() {
          return root._gap.push(['_trackEvent', 'gapBounce', commandArray[1].toString()]);
        }), commandArray[1] * 1000);
      }
    };

    return GapBounceTracker;

  })();

  GapReadTracker = (function() {
    function GapReadTracker() {}

    GapReadTracker.prototype.listen = function(commandArray, gap) {
      var fn;

      if (commandArray.length === 3 && commandArray[0] === '_gapTrackReads' && typeof commandArray[1] === 'number' && typeof commandArray[2] === 'number') {
        gap.variables['gapReadTrackerSeconds'] = 0;
        gap.variables['gapReadTrackerSecondsMax'] = commandArray[1] * commandArray[2];
        return gap.variables['gapReadTrackerInterval'] = root.setInterval(fn = function() {
          if (root._gap.variables['gapReadTrackerSeconds'] < root._gap.variables['gapReadTrackerSecondsMax']) {
            root._gap.push(['_trackEvent', 'gapRead', (root._gap.variables['gapReadTrackerSeconds'] += commandArray[1]).toString()]);
            return fn;
          } else {
            return clearInterval(root._gap.variables['gapReadTrackerInterval']);
          }
        }, commandArray[1] * 1000);
      }
    };

    return GapReadTracker;

  })();

  GapLinkClickTracker = (function() {
    function GapLinkClickTracker() {}

    GapLinkClickTracker.prototype.listen = function(commandArray, gap) {
      if (commandArray.length === 1 && commandArray[0] === '_gapTrackLinkClicks') {
        return root.document.getElementsByTagName('body')[0].onmousedown = function(event) {
          var href, target, text;

          target = event.target || event.srcElement;
          if ((target != null) && (target.nodeName === 'A' || target.nodeName === 'BUTTON')) {
            text = target.innerText || target.textContent;
            href = target.href || '';
            return root._gap.push(['_trackEvent', 'gapLinkClick', text.replace(/^\s+|\s+$/g, '') + ' (' + href + ')']);
          }
        };
      }
    };

    return GapLinkClickTracker;

  })();

  if (root._gap == null) {
    root._gap = [];
  }

  if (root._gaq == null) {
    root._gaq = [];
  }

  (function() {
    var ga, hsc, s;

    hsc = GapUtil.hasSessionCookie();
    ga = root.document.createElement('script');
    ga.async = true;
    ga.type = 'text/javascript';
    ga.src = root.location.protocol === 'https:' ? 'https://ssl' : 'http://www' + '.google-analytics.com/ga.js';
    ga.onload = ga.onreadystatechange = function() {
      root._gapReadTracker = new GapReadTracker();
      return root._gap = new Gap(root._gap, [new GapBounceTracker(hsc), new GapReadTracker(), new GapLinkClickTracker()]);
    };
    s = root.document.getElementsByTagName('script')[0];
    return s.parentNode.insertBefore(ga, s);
  })();

}).call(this);
