NoSequel
========

What is it?
-----------

NoSequel creates a NoSQL container for storing key/value pairs in a persistent database backed by the powerful Sequel O/RM by Sharon Rosner and Jeremy Evans.


How do I use it?
------------------

***Note: Hey, we're still very much under development, so this information may or may not be lying to you.***

### Install it

Add this line to your application's Gemfile:

    gem 'nosequel'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nosequel


### Use it

```ruby
require 'nosequel'

container = NoSequel.register(:my_store)
container[:some_key] = "Some value I care about"
```

That's all there is to it, easy peasy ~~Japanesey~~!

Once you've registered your plugin, your storage container will act much like a Hash, use it to store any string (or Hash or Array) you want to retrieve later.

Behind the scenes, we're actually writing your data in a database with a table named `my_store`.  We (and by _we_, I mean Sequel) only reads and writes to the database when it absolutely has to, so it keeps disk access down to a minimum.  It's also thread-safe, so... YAY!


### Configure it

The defaults (`sqlite`) are going to work pretty well for most people, but hey, if you want to change the database options, go for it!


##### Here's how...

Modify any (or all) of configuration options below via optional extra parameters in your call to #register

|  Item  | Description  | Default Value  |
|:------:|:-------------|:---------------|
| db_type | The database type (sqlite, mysql, postgres, etc.) -- see [Sequel Gem](http://sequel.rubyforge.org/rdoc-adapters/index.html) for complete options. | sqlite |
| db_name | The name of the database (or file, depending on type) | data.db |
| db_user | The database user[:password] to use. | sqlite |
| db_host | The database host[:port] to use. | sqlite |

##### Like This...

```ruby
container = NoSequel.register(:my_plugin, db_name: 'mydb',
                                          db_type: 'mysql',
                                          db_user: 'myname',
                                          db_host: 'localhost')
```

##### Or if you with to include your options in another structure, you can do this too...

```ruby
container_options = NoSequel::Configuration.new( db_name: 'mydb',
                                                 db_type: 'mysql',
                                                 db_user: 'myname',
                                                 db_host: 'localhost')
```

Then just provide `container_options` back to your #register call.


### Notes

If you wish NoSequel could act in a particular way, or had some cool new feature it's missing, by all means, [let me know!](mailto:dyoung522@gmail.com)

However, since NoSequel relies on [Sequel](https://github.com/jeremyevans/sequel) to provide the back-end database support, it [only] supports what they do.  So, if you want to use some fancy new (or anciently old) database model that they don't (yet) support, 'tuff noogies -- go whine to them.  'nuff said on that.  :-)


<!-- TODO: Create documentation -->
For full details and more examples, please see the Documentation


Other Stuff you might want to know
----------------------------------

### Who's Involved with this?

- [Donovan C. Young](mailto:dyoung522@gmail.com)


### Help (I need somebody)!

You can email me directly at dyoung522@gmail.com or find me lurking somewhere on irc.freenode.net


### How can I help?

Easy...

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


