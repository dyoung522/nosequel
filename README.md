NoSequel
========
What is it?
-----------
NoSequel provides a simple, pure ruby, key/value data storage container using a persistent database powered by the Sequel O/RM system by Sharon Rosner and Jeremy Evans.

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

#### Register it
```ruby
require 'nosequel'

# Here, our app is using a table named ':my_store', but this could be anything
# that's meaningful to you.  It doesn't matter if this table already exists.
# If it does, any data stored will be available in the container.
# If not, it will be created on the fly.  Neato!
container = NoSequel.register(:my_store)
```

This sets up a `container` which acts as your primary data store.  Then, all you need to do is...

#### Use it
```ruby
container[:some_key] = "Some value I care about"
```

That's all there is to it, easy peasy ~~Japanesey~~! *[appologies to my East Asian friends, I mean no offense]*

Once registered, your container is a simple, persistent, HASH-like storage system. Use it to store any object you want to persist between runs of you ruby code.  Yup! That's right! You can store just about any Object in your container for later retrieval between runs, or even from another program altogether -- the registration name is the key.

If the value you're storing isn't already a String, we'll serialize it before saving and deserialize it upon retrieval.  Cool, huh?

Behind the scenes, we're actually writing your data to a database (specifically, in a table named `my_store` in our example).  We (and by _we_, I mean Sequel) only read and write to the database when we absolutely have to, so it keeps disk access down to a minimum.  It's also thread-safe, so... YAY!

#### Configure it
The defaults (`sqlite`) are going to work pretty well for most people, but hey, if you want to change the database options, go for it!

##### Here's how...
Send in a hash with the options you would like to change along with your call to #register.  Yup, that's it.

|  Item  | Description  | Default Value  |
|:------:|:-------------|:---------------|
| db_type | The database type (sqlite, mysql, postgres, etc.) -- see [Sequel Gem](http://sequel.rubyforge.org/rdoc-adapters/index.html) for complete options. | sqlite |
| db_name | The name of the database (or file, depending on type) | data.db |
| db_user | The database user[:password] to use. | none |
| db_host | The database host[:port] to use. | localhost |

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
***Hey, you should probably know that we're under development, so this information may or may not be lying to you, however the core public interface should be relatively stable.***

Since NoSequel relies on [Sequel](https://github.com/jeremyevans/sequel) to provide the back-end database support, it **only** supports what they do.  Our goal is to keep this gem lightweight, so if you want to use some fancy new (or anciently old) database model that they don't (yet) support, 'tuff noogies -- go whine to them.  :-)


Other Stuff you might want to know
----------------------------------
### Who's Involved with this?
- [Donovan C. Young](https://github.com/dyoung522)

### Help (I need somebody)!
You can email me directly via dyoung522 at gmail.com or find me lurking somewhere on irc.freenode.net (as dyoung522)

### How can I help?
If you wish NoSequel could act in a particular way, or had some cool new feature it's missing, by all means, [let me know!](mailto:dyoung522@gmail.com), or better yet...

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
