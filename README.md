Cinch::Storage
==============

Description
-----------

Cinch::Storage adds a persistent database backed storage container for use in cinch plugins.

The program is an extension of the Cinch IRCbot framework originally written by [Dominik Honnef](http://dominik.honnef.co)


Installation
------------

Add this line to your application's Gemfile:

    gem 'cinch-storage'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cinch-storage


Usage
-----

***Note: This is still very much under development, so may or may not match up with the code base entirely.***

In your plugin:

```ruby
require 'cinch-storage'

container = Cinch::Extensions::Storage.register(:mytable)
container[:some_key] = 'Some value I want to store persistently'
```
	
That's all there is to it.  Once registered, your storage container will store your data in a Hash-like interface which supports most Hash methods.  It will also persist between runs.

Behind the scenes, your data is stored in a database table named 'mytable', being saved and retrieved from the database automatically (and only when needed) as you use the data.


### Configuration

Cinch::Storage uses the [Sequel](https://github.com/jeremyevans/sequel) Gem, so it supports any database backend supported by Sequel.

When configuring your bot, you may use the following configuration options:

<table>
    <tr><th>Item</th><th>Default</th><th>Description</th></tr>
    <tr><td>bot.config.storage.db_type</td><td>sqlite</td><td>The database type (sqlite, mysql, pg, etc.) -- see the Sequel gem for options.</td></tr>
    <tr><td>bot.config.storage.db_name</td><td>data.db</td><td>The name of the database (or file, depending on type)</td></tr>
    <tr><td>bot.config.storage.db_user</td><td>nil</td><td>The database user[:password] to use.</td></tr>
    <tr><td>bot.config.storage.db_host</td><td>nil</td><td>The database host[:port] to use.</td></tr>
</table>

By default, it will use 'sqlite://data.db' -- which is probably fine for most users, but feel free to use what you're comfortable with.

<!-- TODO: Create documentation -->
For full details and more examples, please see the Documentation


Other Stuff
-----------

### Authors
- [Donovan C. Young](http://github.com/dyoung522)
- [Dominik Honnef](http://dominik.honnef.co) (Cinch)


### Contribute

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

