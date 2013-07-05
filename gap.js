(function() {
  var Api, Dom, Func, MousedownTracker, ScrollTracker, TimeTracker, root;

  Func = (function() {
    function Func() {}

    Func.existy = function(a) {
      return a != null;
    };

    Func.lengthy = function(a) {
      return this.truthy(a) && a.hasOwnProperty('length') && a.length > 0;
    };

    Func.truthy = function(a) {
      return this.existy(a) && (a !== false);
    };

    return Func;

  })();

  Dom = (function() {
    function Dom() {}

    Dom.append = function(element, event, fn) {
      var pfn;

      if (!Func.existy(element) || typeof element !== 'object') {
        this.error('Expected valid element.');
      }
      if (!Func.existy(event) || typeof event !== 'string') {
        this.error('Expected valid event.');
      }
      if (!Func.existy(fn) || typeof fn !== 'function') {
        this.error('Expected valid fn.');
      }
      pfn = element[event];
      if (!Func.existy(pfn)) {
        return element[event] = fn;
      } else {
        return element[event] = function(e) {
          pfn(e);
          return fn(e);
        };
      }
    };

    Dom.debug = function(message) {
      var m;

      if (!Func.lengthy(message) || typeof message !== 'string') {
        this.error('Expected valid debug message.');
      }
      m = ['DEBUG:', message].join(' ');
      if (Func.existy(root.console)) {
        return root.console.log(m);
      } else {
        return root.alert(n);
      }
    };

    Dom.documentHeight = function() {
      return Math.max(root.document.body.scrollHeight || 0, root.document.documentElement.scrollHeight || 0, root.document.body.offsetHeight || 0, root.document.documentElement.offsetHeight || 0, root.document.body.clientHeight || 0, root.document.documentElement.clientHeight || 0);
    };

    Dom.hasCookie = function(name) {
      if (!Func.lengthy(name) || typeof name !== 'string') {
        this.error('Expected valid name.');
      }
      return root.document.cookie.indexOf(name) >= 0;
    };

    Dom.error = function(message) {
      if (!Func.lengthy(message) || typeof message !== 'string') {
        message = 'Expected valid error message.';
      }
      throw new Error(message);
    };

    Dom.scrolledPercent = function() {
      return Math.floor(((this.windowScroll() + this.windowHeight()) / this.documentHeight()) * 100);
    };

    Dom.windowHeight = function() {
      return root.innerHeight || root.document.documentElement.clientHeight || root.document.body.clientHeight || 0;
    };

    Dom.windowScroll = function() {
      return root.pageYOffset || root.document.body.scrollTop || root.document.documentElement.scrollTop || 0;
    };

    return Dom;

  })();

  MousedownTracker = (function() {
    function MousedownTracker(api, state) {
      if (!Func.existy(api) || typeof api !== 'object') {
        Dom.error('Expected api to be an object.');
      }
      if (!Func.existy(state) || typeof state !== 'object') {
        Dom.error('Expected state to be an object.');
      }
      this._api = api;
      this.state = state;
    }

    MousedownTracker.prototype.listen = function(commandArray) {
      switch (commandArray[0]) {
        case '_gapTrackLinkClicks':
          return Dom.append(root.document.getElementsByTagName('body')[0], 'onmousedown', function(event) {
            var gap, href, target, text;

            target = event.target || event.srcElement;
            if (Func.existy(target) && (target.nodeName === 'A' || target.nodeName === 'BUTTON')) {
              gap = root._gap;
              href = target.href || '';
              text = target.innerText || target.textContent;
              return gap.push(['_trackEvent', 'gapLinkClick', text.replace(/^\s+|\s+$/g, '') + ' (' + href + ')']);
            }
          });
      }
    };

    return MousedownTracker;

  })();

  ScrollTracker = (function() {
    function ScrollTracker(api, state) {
      if (!Func.existy(api) || typeof api !== 'object') {
        Dom.error('Expected api to be an object.');
      }
      if (!Func.existy(state) || typeof state !== 'object') {
        Dom.error('Expected state to be an object.');
      }
      this._api = api;
      this.state = state;
    }

    ScrollTracker.prototype.listen = function(commandArray) {
      switch (commandArray[0]) {
        case '_gapTrackBounceViaScroll':
          if (commandArray.length === 2 && typeof commandArray[1] === 'number' && !Func.truthy(this._api.state.cookied) && !Func.truthy(this._api.state.bounced)) {
            this.state.bounceViaScrollPercent = commandArray[1];
            this.state.bounceViaScrollFunction = function() {
              var gap, gapState, percent, trackerState;

              gap = root._gap;
              gapState = root._gap.state;
              percent = Dom.scrolledPercent();
              trackerState = root._gap.trackers.scroll.state;
              if (!Func.truthy(gapState.bounced) && percent >= trackerState.bounceViaScrollPercent) {
                gapState.bounced = true;
                return gap.push(['_trackEvent', 'gapBounceViaScroll', trackerState.bounceViaScrollPercent.toString()]);
              }
            };
            return Dom.append(root, 'onscroll', function(event) {
              var trackerState;

              trackerState = root._gap.trackers.scroll.state;
              if (Func.existy(trackerState.bounceViaScrollTimeout)) {
                clearTimeout(trackerState.bounceViaScrollTimeout);
              }
              return trackerState.bounceViaScrollTimeout = setTimeout(trackerState.bounceViaScrollFunction, 100);
            });
          }
          break;
        case '_gapTrackMaxScroll':
          if (commandArray.length === 2 && typeof commandArray[1] === 'number') {
            this.state.maxScrollPercent = commandArray[1];
            this.state.maxScrollFunction = function() {
              var percent, trackerState;

              percent = Dom.scrolledPercent();
              trackerState = root._gap.trackers.scroll.state;
              if (percent >= trackerState.maxScrollPercent && (!Func.existy(trackerState.maxScrolledPercent) || percent > trackerState.maxScrolledPercent)) {
                return trackerState.maxScrolledPercent = percent;
              }
            };
            Dom.append(root, 'onscroll', function(event) {
              var trackerState;

              trackerState = root._gap.trackers.scroll.state;
              if (Func.existy(trackerState.maxScrollTimeout)) {
                clearTimeout(trackerState.maxScrollTimeout);
              }
              return trackerState.maxScrollTimeout = setTimeout(trackerState.maxScrollFunction, 100);
            });
            return Dom.append(root, 'onunload', function(event) {
              var gap, trackerState;

              gap = root._gap;
              trackerState = root._gap.trackers.scroll.state;
              if (Func.existy(trackerState.maxScrolledPercent)) {
                return gap.push(['_trackEvent', 'gapMaxScroll', trackerState.maxScrolledPercent.toString()]);
              }
            });
          }
      }
    };

    return ScrollTracker;

  })();

  TimeTracker = (function() {
    function TimeTracker(api, state) {
      if (!Func.existy(api) || typeof api !== 'object') {
        Dom.error('Expected api to be an object.');
      }
      if (!Func.existy(state) || typeof state !== 'object') {
        Dom.error('Expected state to be an object.');
      }
      this._api = api;
      this.state = state;
    }

    TimeTracker.prototype.listen = function(commandArray) {
      var fn;

      switch (commandArray[0]) {
        case '_gapTrackBounceViaTime':
          if (commandArray.length === 2 && typeof commandArray[1] === 'number' && !Func.truthy(this._api.state.cookied) && !Func.truthy(this._api.state.bounced)) {
            return this.state.bounceViaTimeTimeout = root.setTimeout((function() {
              var gap, gapState;

              gap = root._gap;
              gapState = root._gap.state;
              if (!Func.truthy(gapState.bounced)) {
                gapState.bounced = true;
                return gap.push(['_trackEvent', 'gapBounceViaTime', commandArray[1].toString()]);
              }
            }), commandArray[1] * 1000);
          }
          break;
        case '_gapTrackReads':
          if (commandArray.length === 3 && typeof commandArray[1] === 'number' && typeof commandArray[2] === 'number') {
            this.state.readsSeconds = 0;
            this.state.readsSecondsMax = commandArray[1] * commandArray[2];
            return this.state.readsInterval = root.setInterval(fn = (function() {
              var gap, trackerState;

              gap = root._gap;
              trackerState = root._gap.trackers.time.state;
              if (trackerState.readsSeconds < trackerState.readsSecondsMax) {
                gap.push(['_trackEvent', 'gapRead', (trackerState.readsSeconds += commandArray[1]).toString()]);
                return fn;
              } else {
                return clearInterval(trackerState.readsInterval);
              }
            }), commandArray[1] * 1000);
          }
      }
    };

    return TimeTracker;

  })();

  Api = (function() {
    function Api(commands, gaq, state) {
      if (!Func.existy(commands) || typeof commands !== 'object') {
        Dom.error('Expected commands to be an object.');
      }
      if (!Func.existy(gaq) || typeof gaq !== 'object') {
        Dom.error('Expected gaq to be an object.');
      }
      if (!Func.existy(state) || typeof state !== 'object') {
        Dom.error('Expected state to be an object.');
      }
      this._gaq = gaq;
      this.state = state;
      this.trackers = {};
      this.subscribe('mousedown', new MousedownTracker(this, {}));
      this.subscribe('scroll', new ScrollTracker(this, {}));
      this.subscribe('time', new TimeTracker(this, {}));
      if (Func.lengthy(commands)) {
        this.push(commands);
      }
    }

    Api.prototype.isCommand = function(command) {
      return Func.lengthy(command) && {}.toString.call(command) === '[object Array]';
    };

    Api.prototype.publish = function(command) {
      var k, t, _ref, _results;

      if (!this.isCommand(command)) {
        Dom.error('Expected valid command.');
      }
      _ref = this.trackers;
      _results = [];
      for (k in _ref) {
        t = _ref[k];
        _results.push(t.listen(command));
      }
      return _results;
    };

    Api.prototype.push = function(command) {
      var i, _i, _len, _results;

      if (!this.isCommand(command)) {
        Dom.error('Expected valid command.');
      }
      if (this.isCommand(command[0])) {
        _results = [];
        for (_i = 0, _len = command.length; _i < _len; _i++) {
          i = command[_i];
          _results.push(this.push(i));
        }
        return _results;
      } else {
        this.publish(command);
        if (command[0].indexOf('_gap') !== 0) {
          this._gaq.push(command);
          if (Func.truthy(this.state.debugging)) {
            return Dom.debug(['[', command.toString(), ']'].join(' '));
          }
        }
      }
    };

    Api.prototype.subscribe = function(key, tracker) {
      if (!Func.existy(key) || typeof key !== 'string') {
        Dom.error('Expected key to be a string.');
      }
      if (!Func.existy(tracker) || typeof tracker !== 'object') {
        Dom.error('Expected tracker to be an object.');
      }
      return this.trackers[key] = tracker;
    };

    return Api;

  })();

  root = window;

  if (root._gap == null) {
    root._gap = [];
  }

  if (root._gaq == null) {
    root._gaq = [];
  }

  (function() {
    var ga, hasCookie, s;

    hasCookie = Dom.hasCookie('__utmb');
    ga = root.document.createElement('script');
    ga.async = true;
    ga.type = 'text/javascript';
    ga.src = root.location.protocol === 'https:' ? 'https://ssl' : 'http://www' + '.google-analytics.com/ga.js';
    ga.onload = ga.onreadystatechange = function() {
      root._gap = new Api(root._gap, root._gaq, {
        cookied: hasCookie,
        debugging: Func.truthy(root._gapDebug)
      });
      return root.gap = {
        Api: Api,
        Dom: Dom,
        Func: Func,
        MousedownTracker: MousedownTracker,
        ScrollTracker: ScrollTracker,
        TimeTracker: TimeTracker
      };
    };
    s = root.document.getElementsByTagName('script')[0];
    return s.parentNode.insertBefore(ga, s);
  })();

}).call(this);
