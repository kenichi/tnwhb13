hack battle 2013!
=================

### APIs

* [Pearson Eyewitness](http://developer.pearson.com/api/eyewitness-guides-api/)
* Esri Geotriggers *unreleased*
* ~~Bol.com~~

### Description

This repo contains a [Turmeric](https://github.com/kenichi/turmeric) based ruby webservice
that talks to both Pearson Eyewitness and Esri Geotriggers. It offers routes to check for
guidebook entries, and create Geotriggers from those entries.

It also contians a iPhone app that posts its location data to the tuby webservice. When that
is done, it shows the user pins on a map of the interesting places that the Pearson API came
back with. It also registers itself to receive Push Notifications from the Geotriggers, that
were created by the ruby webservice.

When a user loads up this app, if they are in one of the cities that the Pearson API has 
guidebooks for, they will see the pins. They can put their phone away, and when they near
a place of interest, Esri's Geotriggers platform will push notify the device.

### NOT DONE

The push notification was to contain an identifier that would link back to the title of
the location; this would, in turn, yield a "offer URL" from the [bol.com](bol.com) API, giving
the user the oppurtunity to purchase any products yielded by a search of the place's name.

I got the bol.com integration working, but ran out of time with the push notifications.

<3 Kenichi
