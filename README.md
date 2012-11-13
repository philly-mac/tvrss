# About

This is small web app that will allow you to search from a host of tv shows from various countries (if it is on tvrage.com you will be able to find it with this app),
and import the air schedule to a local database. Then you can search between two dates and display an rss feed of the episodes
that aired on those dates.

# Why

I used to use mytvrss.com, and while it is a good service, it never seems to have the new shows early enough, and they never
responded to my request to add shows. Also when they did add new shows, they never really tweeted about it or had a way to say
"hey there is a new show". Which meant I would have to search the whole list of shows to see if there was something new or if
the show I wanted was there. This is very tedious!

Also mytvrss.com uses the data service from tvrage.com, and while that service is great, and they have a wealth of data, their interface
is complicated, crowded and just didn't serve my needs. I need a balance of the two sites.

I am a developer, so I thought, why don't I just write a small web app that would do exactly what I want, using the data service from
tvrage.com. So that is what I did.

# 30 (or thereabouts) Second Install

Depending on whether you have the required tools installed on your machine, you can get this app installed and usable in 30 seconds.
Heres how.

    git clone git://github.com/philly-mac/tvrss.git
    cd tvrss
    bundle install
    bundle exec rake db:create
    bundle exec rake db:migrate
    bundle exec rake db:seed EMAIL=YOUR@EMAIL.com PASSWORD=password
    bundle exec rails start


Then browse to http://localhost:3000/

    default username = user@test.com
    default password = password

Enjoy tvrss!

# Features

- Search for show and add it to your database
- Show an rss feed of any past, current and future episodes of an show
- Update the episodes of a show
- Update the episodes of all shows
- Delete a show from the database, will also remove all episodes
- Show an rss feed of all episodes of all shows in your database between two dates


- www.tvrage.com xml service for the data

