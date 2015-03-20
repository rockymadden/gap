#GAP - Google Analytics auto Push [![Build Status](https://travis-ci.org/rockymadden/gap.png?branch=master)](https://travis-ci.org/rockymadden/gap)
Dead simple wrapper around the Google Analytics API which fixes default tracking methodologies and provides automatic tracking of micro user behaviors.

##Installation
There is no need to include any of the default Google Analytics tracking code, as GAP takes care of this for you. Simply specify as a [Bower](http://bower.io/) dependency and then include the tracking code on your site:

```javascript
var _gap = _gap || [];

// Standard Google Analytics pushes, just with _gap.push.
// You can push anything, just like normal, via _gap.push instead of _gaq.push.
_gap.push(['_setAccount', 'UA-XXXXXX-X']); // Change to your account.
_gap.push(['_trackPageview']);

// With both bounce trackers active, any user who scrolls down 50% OR
// stays 10 seconds is not counted as a bounce. You can use just one, or none.
_gap.push(['_gapTrackBounceViaTime', 10]); // Optionally change (min seconds).
_gap.push(['_gapTrackBounceViaScroll', 50]); // Optionally change (min percentage).

// Every 20 seconds, push a read event so that time on site is more accurate.
// Only allow 30 of these read events per page.
_gap.push(['_gapTrackReads', 20, 30]); // Optionally change (cadence and max read events per page).

// Anytime a user clicks a link, internal or external, push the event.
_gap.push(['_gapTrackLinkClicks']);

// Push the maximum percentage scrolled.
_gap.push(['_gapTrackMaxScroll', 25]); // Optionally change (min percentage).

(function() {
	var gap = document.createElement('script');
	gap.async = true;
	gap.type = 'text/javascript';
	gap.src = '/bower_components/gap/dst/gap.min.js'; // Change, if needed.

	var s = document.getElementsByTagName('script')[0];
	s.parentNode.insertBefore(gap, s);
})();
```

## Trackers

__gapTrackBounceViaScroll__

Logs a single ```gapBounceViaScroll``` event after scrolling n percentage down the page. This event will only fire once per session. This tracker uses debouncing. The following scenario helps illustrate why you might want to leverage this tracker:

* User A arrives on your website. He finds a wealth of information he is looking for on the first landing page. He fully scrolls/reads the entire page and then departs. By default, this is considered a bounce in Google Analytics.


```javascript
_gap.push([
	'_gapTrackBounceViaScroll',
	50 // Percentage of the page scrolled before this user is not considered a bounce.
]);
```

More information on this subject, [straight from Google](http://analytics.blogspot.com/2012/07/tracking-adjusted-bounce-rate-in-google.html)

-----

__gapTrackBounceViaTime__

Logs a single ```gapBounceViaTime``` event after n seconds. This event will only fire once per session. The following scenario helps illustrate why you might want to leverage this tracker:

* User A arrives on your website. She finds a wealth of information she is looking for on the first landing page. She spends 15 minutes reading and then departs. By default, this is considered a bounce in Google Analytics.

```javascript
_gap.push([
	'_gapTrackBounceViaTime',
	10 // Number of seconds before this user is not considered a bounce.
]);
```

More information on this subject, [straight from Google](http://analytics.blogspot.com/2012/07/tracking-adjusted-bounce-rate-in-google.html).

-----

__gapTrackReads__

Logs ```gapRead``` events every n seconds. Each new event label is updated as time progresses. For instance, with a 10 second cadence the first event label would be 10, the second would be 20, and so on. The following scenarios help illustrate why you might want to leverage this tracker:

* User A arrives on your website. He finds a wealth of information he is looking for on the first landing page. He spends 5 minutes reading and then departs. By default, the time on site for this user is 0 seconds in Google Analytics.
* User B arrives on your website. He doesn't find what he is looking for on the first page, so 10 seconds after arriving he lands on the second, and final, page of his visit. He finds a wealth of information, and he spends 30 minutes reading and then departs. By default, the time on site for this user is 10 seconds in Google Analytics.
* You have redesigned your website hoping to improve user engagement (e.g. increase time on site and lower bounce rate). Because you used the default implementation of the Google Analytics code, your bounce rate is over stated and your time on site is under stated. After the redesign, you see positive numbers on both these fronts. Bounce rate is down and time on site is up. Both these data points are not only incorrect, but the opposite could be true. Your time on site could, in actuality, be lower than before. Your bounce rate could, in actuality, be higher than before.

Polling cadence can be changed as well as the number of events total this tracker can utilize per page. There is a limit of [500 total events tracked per session](https://developers.google.com/analytics/devguides/collection/gajs/limits-quotas), so keep this in mind.

```javascript
_gap.push([
	'_gapTrackReads',
	20, // Polling cadence, in seconds.
	30 // Maximum number of these events tracked per page.
]);
```

More information on this subject, [straight from Google](http://analytics.blogspot.com/2012/07/tracking-adjusted-bounce-rate-in-google.html).

-----

__gapTrackLinkClicks__

Logs ```a``` and ```button``` mousedown events (i.e. user clicks) via event delegation. Event action logged is ```gapLinkClick```. Event label logged is ```#{linkName} (#{linkURL})```.

```javascript
_gap.push(['_gapTrackLinkClicks']);
```

__gapTrackMaxScroll__

Logs ```gapMaxScroll``` events which indicate the maximum percentage of the page the user scrolled. This event will be pushed up to once per page. Should the user not scroll past the minimum percentage required, no event will be pushed. The event label indicates the maximum percentage scrolled. This tracker uses debouncing.

```javascript
_gap.push([
	'_gapTrackMaxScroll',
	25 // Minimum percentage scrolled before event is pushed.
]);
```

## License
```
The MIT License (MIT)

Copyright (c) 2015 Rocky Madden (https://rockymadden.com/)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
