SHWordpress
===========

## Turns a Wordpress JSON feed into a native iOS app.

This is a week-end project, that can be a good enough structure to build an app for a Wordpress-based CMS.

## Features in this version :
	- Gets content when necessary (when there is changes, or the name of the feed changes).
		Debug flag : pulls content everytime.
	- Caching (all posts are going into a CoreData database), useful for offline mode.
	- Simple JSON structure.

## Needs to be done :
	- Pagination (pull to refresh / infinite scroll)
	- Get posts from Custom Post Types.
	- For now we display the HTML content of the page in a UIWebView, but because we have the separate elements in a database, we can do much better.