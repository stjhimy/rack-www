Changelog
=========

Version 2.3.0 (July 17, 2017)
-----------------------------

* Allow host-regex option

Version 2.2.0 (August 11, 2016)
-----------------------------

* Do not append port for SSL redirect

Version 2.1.0
-----------------------------

* Ignore rack-www when request host is an IP address

Version 2.0.0
-----------------------------

* Update EVERYTHING

Version 1.5
-----------------------------

* Bug fixes

Version 1.4
-----------------------------

* Respect server port
* Body responds to :each
* Rack::Lint on tests

Version 1.3
-----------------------------

* Added possibility to redirect to any given :subdomain [Ryan Weald (https://github.com/rweald)]
* Added more tests

Version 1.2
-----------------------------

* Redirects to the right url without calling the app
* Keep the path when redirecting
* Keep the query string when redirecting
* Added more tests

Version 1.1
-----------------------------

* Added possibility to redirects with www or without www
* Added possibility to set a param :message to show while redirecting

Version 1.0
-----------------------------

* Redirects all traffic to www
