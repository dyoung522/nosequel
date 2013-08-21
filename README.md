Cinch::Storage
==============

What is it?
-----------

Cinch::Storage adds a persistent database backed storage container for use in cinch plugins.
It's an extension of the Cinch IRC bot framework originally written by [Dominik Honnef](http://dominik.honnef.co)


How do I use it?
------------------

***Note: Hey, we're still very much under development, so this information may or may not be lying to you. Shhhh!***

### Install it

Add this line to your application's Gemfile:

    gem 'cinch-storage'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cinch-storage


### Use it

```ruby
require 'cinch-storage'

container = Cinch::Extensions::Storage.register(:my_plugin)
container[:some_key] = "Some value I care about"
```

That's all there is to it, easy peasy ~Japanesey~!

Once you've registered your plugin, your storage container will act just like a Hash, use it to store anything you want to retrieve later.

Behind the scenes, we're actually writing your data in a database with a table named `my_plugin`.  We (and by _we_, I mean Sequel) only reads and writes to the database when it absolutely has to, so it keeps disk access down to a minimum.  It's also thread-safe, so... YAY!


### Configure it

The defaults (`sqlite`) are going to work pretty well for most people, but hey, if you have something fancier in mind and want to change the database options, go for it!

##### Here's how...

Just modify any (or all) of configuration options below before you call Storage.register, and you're golden.

<table>
    <tr>
        <th>Item</th>
        <th>Description</th>
        <th>Default</th></tr>
    <tr>
        <td>bot.config.storage.db_type</td>
        <td>The database type (sqlite, mysql, postgres, etc.) -- see http://sequel.rubyforge.org/rdoc-adapters/index.html for complete options.</td>
        <td>sqlite</td>
    </tr>
    <tr>
        <td>bot.config.storage.db_name</td>
        <td>The name of the database (or file, depending on type)</td>
        <td>data.db</td>
    </tr>
    <tr>
        <td>bot.config.storage.db_user</td>
        <td>The database user[:password] to use.</td>
        <td>nil</td>
    </tr>
    <tr>
        <td>bot.config.storage.db_host</td>
        <td>The database host[:port] to use.</td>
        <td>nil</td>
    </tr>
</table>


### Notes

Since Cinch::Storage uses [Sequel](https://github.com/jeremyevans/sequel), it supports anything they do.  If you want to use some fancy new (or anciently old) database model they don't support, 'tuff noogies -- go whine to them.  'nuff said on that.  :-)

If you wish cinch-storage could act in a particular way, or had some cool new feature, by all means, [let me know!](mailto:dyoung522@gmail.com)

<!-- TODO: Create documentation -->
For full details and more examples, please see the Documentation


Other Stuff you might want to know
----------------------------------

### Who's Involved with this?

- [Donovan C. Young](mailto:dyoung522@gmail.com) (wrote this)
- [Dominik Honnef](http://dominik.honnef.co) (wrote Cinch)


### Help (I need somebody)!

You can email me directly at dyoung522@gmail.com or find me lurking in the #cinch channel on irc.freenode.net


### How can I help?

Easy...

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


