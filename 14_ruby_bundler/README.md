# Bundler

As you saw before, you may need different versions of gems for different project. Bundler sets up an environment for each project where you can specify exact versions of the gems you are using.

## Usage
First, you declare these dependencies in a file at the root of your application, called `Gemfile`. It looks something like this:

```ruby
source 'https://rubygems.org'

gem 'sinatra'
gem 'nokogiri', '~> 1.6.1'
```

This `Gemfile` says a few things. First, it says that bundler should look for gems declared in the `Gemfile` at `https://rubygems.org` by default. If some of your gems need to be fetched from a private gem server, this default source can be overridden for those gems.

Next, you declare a few dependencies:

- on any version of `sinatra`
- on a specific version of `nokogiri` that is `>= 1.6.1` but `< 1.7.0`

After declaring your first set of dependencies, you tell bundler to go get them:

```bash
$ bundle install
```

or just

```bash
$ bundle
```

which is a shortcut for `bundle install`

Bundler will connect to `rubygems.org` (and any other sources that you declared), and find a list of all of the required gems that meet the requirements you specified. Because all of the gems in your `Gemfile` have dependencies of their own (and some of those have their own dependencies), running `bundle install` on the `Gemfile` above will install quite a few gems.

```bash
$ bundle install
Fetching gem metadata from https://rubygems.org/.........
Resolving dependencies...
Using bundler 2.0.2
Fetching mini_portile2 2.1.0
Installing mini_portile2 2.1.0
Using mustermann 1.0.3
Fetching nokogiri 1.6.8.1
Installing nokogiri 1.6.8.1 with native extensions
Using rack 2.0.7
Fetching rack-protection 2.0.7
Installing rack-protection 2.0.7
Using tilt 2.0.9
Fetching sinatra 2.0.7
Installing sinatra 2.0.7
Bundle complete! 2 Gemfile dependencies, 8 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
```

If any of the needed gems are already installed, Bundler will use them. After installing any needed gems to your system, bundler writes a snapshot of all of the gems and versions that it installed to `Gemfile.lock`.

Bundler makes sure that Ruby can find all of the gems in the `Gemfile` (and all of their dependencies).

For your application (such as a Sinatra application), you will need to set up bundler before trying to require any gems. At the top of the first file that your application loads (for Sinatra, the file that calls `require 'sinatra'`), put the following code:

```ruby
require 'rubygems'
require 'bundler/setup'
```

This will automatically discover your `Gemfile`, and make all of the gems in your `Gemfile` available to Ruby (in technical terms, it puts the `lib` folder of the gems  into `$LOAD_PATH`, as we saw earlier).

Now that your code is available to Ruby, you can require the gems that you need. For instance, you can `require 'sinatra'`.

If you have a lot of dependencies, you might want to say "require all of the gems in my `Gemfile`". To do this, put the following code immediately following `require 'bundler/setup'`:

```ruby
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
```

For our example Gemfile, this line is exactly equivalent to:

```ruby
require 'sinatra'
require 'nokogiri'
```

For such a small `Gemfile`, we'd advise you to skip `Bundler.require` and just require the gems by hand.

For much larger `Gemfile`s, using `Bundler.require` allows you to skip repeating a large stack of requirements.


# Checking your dependency list into version control

After developing your application for a while, check in the application together with the `Gemfile` and `Gemfile.lock` snapshot. Now, your repository has a record of the exact versions of all of the gems that you used the last time you know for sure that the application worked.

Keep in mind that while your `Gemfile` lists only three gems (with varying degrees of version strictness), your application depends on dozens of gems, once you take into consideration all of the implicit requirements of the gems you depend on.

This is important: **the `Gemfile.lock` makes your application a single package of both your own code and the third-party code it ran the last time you know for sure that everything worked**. Specifying exact versions of the third-party code you depend on in your `Gemfile` would not provide the same guarantee, because gems usually declare a range of versions for their dependencies.

The next time you run `bundle install` on the same machine, bundler will see that it already has all of the dependencies you need, and skip the installation process.

Do not check in the `.bundle` directory, or any of the files inside it. Those files are specific to each particular machine, and are used to persist installation options between runs of the `bundle install` command.

If you have run `bundle pack`, the gems (although not the git gems) required by your bundle will be downloaded into `vendor/cache`. Bundler can run without connecting to the internet (or the RubyGems server) if all the gems you need are present in that folder and checked in to your source control. This is an **optional** step, and not recommended, due to the increase in size of your source control repository.

## Sharing your application with other developers

When your co-developers check out your code, it will come with the exact versions of all the gems your application used on the machine that you last developed on (in the `Gemfile.lock`). When \*\*they\*\* run `bundle install`, bundler will find the `Gemfile.lock` and skip the dependency resolution step. Instead, it will install all of the same gems that you used on the original machine.

In other words, you don't have to guess which versions of the dependencies you should install. This relieves a large maintenance burden from application developers, because all machines always run the exact same dependencies, i.e. gems.

## Updating a dependency

Of course, at some point, you might want to update the version of a particular dependency your application relies on. For instance, you might want to update `nokogiri` to `1.10.4` - the latest version.

Here we have to change the Gemfile because we limited `nokogiri` to be a version 1.6.x. Now we wan't the latest version, and it's time to remove the version restriction in Gemfile, and let it be up to Gemfile.lock, to keep track of the version of `nokogiri` going forward.

Thus Gemfile is now

```ruby
source 'https://rubygems.org'

gem 'sinatra'
gem 'nokogiri'
```

Rerunning bundle install, will not give us anything, since nokogiri is still locked at version `1.6.8` in Gemfile.lock.

You may feel tempted to just delete the Gemfile.lock and rerun `bundle install`, but importantly, just because you're updating one dependency, it doesn't mean you want to re-resolve all of your dependencies and use the latest version of everything.

Instead we wan't to update our dependencies one-by-one, in a controlled way. To update `nokogiri` only, you want to use the `bundle update` command:

```bash
$ bundle update nokogiri
```

Now `nokogiri` and its dependencies will be updated to the latest version allowed by the `Gemfile` (in this case, the latest version available). It will not modify any other dependencies.

## Bootstraping a ruby (gem) project with Bundler

If you need to build a new `gem` (with RSpec as testing framework), then use `bundle gem` for that

```bash
$ bundle gem --test=rspec mygem
Creating gem 'mygem'...
      create  mygem/Gemfile
      create  mygem/lib/mygem.rb
      create  mygem/lib/mygem/version.rb
      create  mygem/mygem.gemspec
      create  mygem/Rakefile
      create  mygem/README.md
      create  mygem/bin/console
      create  mygem/bin/setup
      create  mygem/.gitignore
      create  mygem/.travis.yml
      create  mygem/.rspec
      create  mygem/spec/spec_helper.rb
      create  mygem/spec/mygem_spec.rb
Initializing git repo in /Users/u0157312/src/mygem
Gem 'mygem' was successfully created. For more information on making a RubyGem visit https://bundler.io/guides/creating_gem.html
```

and that gives you

```bash
$ tree mygem
mygem
├── Gemfile
├── README.md
├── Rakefile
├── bin
│   ├── console
│   └── setup
├── lib
│   ├── mygem
│   │   └── version.rb
│   └── mygem.rb
├── mygem.gemspec
└── spec
    ├── mygem_spec.rb
    └── spec_helper.rb
```

If you remove the `.gemspec` file, it's actually a nice skeleton for a Ruby app.
