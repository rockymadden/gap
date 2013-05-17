#Google Analytics Poller (GAP)
If you are puzzled as to why you have so many of your users have a time on site of 0 to 10 seconds, GAP can help you. If you are puzzled as to why your bounce rate is so high, GAP can help you. If you want to accurately test changes to your website and how they truly affect user engagement, GAP can help you. The default implementation of the Google Analytics tracking code has these undesirable traits. The following scenarios help illustrate: 

* User A arrives on your website. She finds a wealth of information she is looking for on the first landing page. She spends 15 minutes reading and then departs. By default, this is considered a bounce.
* User B arrives on your website. He finds a wealth of information he is looking for on the first landing page. He spends two hours reading and then departs. By default, the time on site for this user is 0 seconds.
* User C arrives on your website. He doesn't find what he is looking for on the first page, so 10 seconds after arriving he lands on the second, and final, page of his visit. He finds a wealth of information, and he spends 30 minutes reading and then departs. By default, the time on site for this user is 10 seconds.
* You have redesigned your website hoping to improve user engagement (e.g. increase time on site and lower bounce rate). Because you used the default implementation of the Google Analytics code, your bounce rate is over stated and your time on site is under stated. After the redesign, you see positive numbers on both these fronts. Bounce rate is down and time on site is up. Both these data points are not only incorrect, but the opposite could be true. Your time on site could, in actuality, be lower than before. Your bounce rate could, in actuality, be higher than before.
* More information on this subject, [straight from Google](http://analytics.blogspot.com/2012/07/tracking-adjusted-bounce-rate-in-google.html).

The Google Analytics Poller provides a simple solution to remedy these issues. It thinly wraps the Google Analytics ```_gaq``` API and adds reoccurring event polling. These "read" events are captured every n seconds, where n is the number of seconds you specify.

## Usage
There is no need to include any of the default Google Analytics tracking code, as GAP takes care of all this for you. Simply [download the gap.js](https://raw.github.com/rockymadden/gap/master/gap.js) file, place on your server, and update the noted fields below. That's it!

```javascript
var _gap = _gap || [];
_gap.push(["_setAccount", "UA-XXXXXX-X"]); // CHANGE.
_gap.push(["_trackPageview"]);
_gap.push(["_gapTrackRead", "10"]); // POLLING CADIENCE, CHANGE IF DESIRED.

(function() {
	var gap = document.createElement("script");
	gap.type = "text/javascript";
	gap.async = true;
	gap.src = "//yourdomain.com/js/gap.js"; // CHANGE.

	var s = document.getElementsByTagName("script")[0];
	s.parentNode.insertBefore(gap, s);
})();
```

## Versioning
[Semantic Versioning v2.0](http://semver.org/)

## License
[Apache License v2.0](http://www.apache.org/licenses/LICENSE-2.0)