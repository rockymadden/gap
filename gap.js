(function() {
  var Gap, GapLinkClickTracker, GapReadTracker, root;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  Gap = (function() {
    Gap.prototype.subscribers = [];

    function Gap(previous, subscribers) {
      var subscriber, _i, _len;

      for (_i = 0, _len = subscribers.length; _i < _len; _i++) {
        subscriber = subscribers[_i];
        this.isArray(subscribers) && this.subscribe(subscriber);
      }
      this.isArray(previous) && this.push(previous);
    }

    Gap.prototype.isArray = function(args) {
      return (args != null) && {}.toString.call(args) === '[object Array]' && args.length > 0;
    };

    Gap.prototype.publish = function(commandArray) {
      var subscriber, _i, _len, _ref, _results;

      _ref = this.subscribers;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        subscriber = _ref[_i];
        _results.push(subscriber.listen(commandArray));
      }
      return _results;
    };

    Gap.prototype.push = function(commandArray) {
      var i, _i, _len, _results;

      if (this.isArray(commandArray) && this.isArray(commandArray[0])) {
        _results = [];
        for (_i = 0, _len = commandArray.length; _i < _len; _i++) {
          i = commandArray[_i];
          _results.push(this.push(i));
        }
        return _results;
      } else if (this.isArray(commandArray)) {
        if (commandArray[0].indexOf('_gap') === 0) {
          return this.publish(commandArray);
        } else {
          root._gaq.push(commandArray);
          return (typeof _gapDebug !== "undefined" && _gapDebug !== null) && _gapDebug && (root.console != null) && root.console.log('Pushed: ' + commandArray);
        }
      }
    };

    Gap.prototype.subscribe = function(subscriber) {
      return this.subscribers.push(subscriber);
    };

    return Gap;

  })();

  GapReadTracker = (function() {
    function GapReadTracker() {}

    GapReadTracker.prototype.listen = function(commandArray) {
      var fn;

      if (commandArray.length === 2 && commandArray[0] === '_gapTrackReads' && typeof commandArray[1] === 'number') {
        root._gapSeconds = 0;
        return root.setInterval(fn = function() {
          root._gap.push(['_trackEvent', 'gapRead', (root._gapSeconds += commandArray[1]).toString()]);
          return fn;
        }, commandArray[1] * 1000);
      }
    };

    return GapReadTracker;

  })();

  GapLinkClickTracker = (function() {
    function GapLinkClickTracker() {}

    GapLinkClickTracker.prototype.listen = function(commandArray) {
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
    var ga, s;

    ga = document.createElement('script');
    ga.async = true;
    ga.type = 'text/javascript';
    ga.src = root.location.protocol === 'https:' ? 'https://ssl' : 'http://www' + '.google-analytics.com/ga.js';
    ga.onload = ga.onreadystatechange = function() {
      root._gapReadTracker = new GapReadTracker();
      return root._gap = new Gap(root._gap, [new GapReadTracker(), new GapLinkClickTracker()]);
    };
    s = document.getElementsByTagName('script')[0];
    return s.parentNode.insertBefore(ga, s);
  })();

}).call(this);
