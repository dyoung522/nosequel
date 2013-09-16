NoSequel
========
What is it?
-----------
NoSequel provides a NoSQL data container for storing key/value pairs using a persistent database.  It's powered by the Sequel O/RM system by Sharon Rosner and Jeremy Evans.

How do I use it?
------------------
Glad you asked!

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

Once you've registered your plugin, your storage container will act much like a Hash, use it to store any object you want to retrieve later.  If the value you're storing isn't already a String, we'll serialize it before saving.

Behind the scenes, we're actually writing your data to a database in a table named `my_store`.  We (and by _we_, I mean Sequel) only read and write to the database when we absolutely have to, so it keeps disk access down to a minimum.  It's also thread-safe, so... YAY!

### Configure it
The defaults (`sqlite`) are going to work pretty well for most people, but hey, if you want to change the database options, go for it!

##### Here's how...
Send in a hash with the options you would like to change along with your call to #register.  Yup, that's it.

|  Item  | Description  | Default Value  |
|:------:|:-------------|:---------------|
| db_type | The database type (sqlite, mysql, postgres, etc.) -- see [Sequel Gem](http://sequel.rubyforge.org/rdoc-adapters/index.html) for complete options. | sqlite |
| db_name | The name of the database (or file, depending on type) | data.db |
| db_user | The database user[:password] to use. | sqlite |
| db_host | The database host[:port] to use. | sqlite |

##### Like This...
```ruby
container = NoSequel.register(
    :my_plugin,
    db_name: 'mydb',
    db_type: 'mysql',
    db_user: 'myname',
    db_host: 'localhost'
)
```

### Notes
***Hey, you should know that we're still very much under development, so this information may or may not be lying to you.***

If you wish NoSequel could act in a particular way, or had some cool new feature it's missing, by all means, [let me know!](mailto:dyoung522@gmail.com)

However, since NoSequel relies on [Sequel](https://github.com/jeremyevans/sequel) to provide the back-end database support, it **only** supports what they do.  Our goal is to keep this gem lightweight, so if you want to use some fancy new (or anciently old) database model that they don't (yet) support, 'tuff noogies -- go whine to them.  :-)

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
