---
title: PHP session timeout
author: Mikael Ståldal
type: post
date: 2011-07-20T09:13:40+00:00
slug: php-session-timeout
category:
  - PHP
  - web

---
The developers of [PHP][1] has, in their infinite wisdom, decided that the default session timeout should be 24 minutes (1440 seconds).

This means that if you have a [MediaWiki][2] wiki and are editing a single page for half an hour and then click the save button, you are logged out and all your changes are lost. I just learned this the hard way.

Fortunately, you can change this with the `session.gc_maxlifetime` parameter in `php.ini`. So set this to a higher &#8211; more sane &#8211; value, such as 86400 (24 hours).

 [1]: http://www.php.net/
 [2]: http://www.mediawiki.org/