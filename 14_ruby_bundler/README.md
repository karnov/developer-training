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

You may feel an eager to just delete the Gemfile.lock and rerun `bundle install`, but importantly, just because you're updating one dependency, it doesn't mean you want to re-resolve all of your dependencies and use the latest version of everything.

In our example, you only have two dependencies, but even in this case, updating everything can cause complications.

## Updating a Gem Without Modifying the Gemfile[](https://bundler.io/rationale.html#updating-a-gem-without-modyfying-the-gemfile)

Sometimes, you want to update a dependency without modifying the Gemfile. For example, you might want to update to the latest version of `rack-cache`. Because you did not declare a specific version of `rack-cache` in the `Gemfile`, you might want to periodically get the latest version of `rack-cache`. To do this, you want to use the `bundle update` command:

    $ bundle update rack-cache



This command will update `rack-cache` and its dependencies to the latest version allowed by the `Gemfile` (in this case, the latest version available). It will not modify any other dependencies.

It will, however, update dependencies of other gems if necessary. For instance, if the latest version of `rack-cache` specifies a dependency on `rack >= 1.5.2`, bundler will update `rack` to `1.5.2` even though you have not asked bundler to update `rack`. If bundler needs to update a gem that another gem depends on, it will let you know after the update has completed.

If you want to update every gem in the Gemfile to the latest possible versions, run:

    $ bundle update



This will resolve dependencies from scratch, ignoring the `Gemfile.lock`. If you do this, keep `git reset --hard` and your test suite in your back pocket. Resolving all dependencies from scratch can have surprising results, especially if a number of the third-party packages you depend on have released new versions since you last did a full update.

## Summary[](https://bundler.io/rationale.html#summary)

## A Simple Bundler Workflow[](https://bundler.io/rationale.html#a-simple-bundler-workflow)

-   When you first create a Rails application, it already comes with a `Gemfile`. For another kind of application (such as Sinatra), run:

        $ bundle init



    The `bundle init` command creates a simple `Gemfile` which you can edit.

-   Next, add any gems that your application depends on. If you care which version of a particular gem that you need, be sure to include an appropriate version restriction:

        source 'https://rubygems.org'

        gem 'sinatra', '~1.3.6'
        gem 'rack-cache'
        gem 'rack-bug'



-   If you don't have the gems installed in your system yet, run:

        $ bundle install



-   To update a gem's version requirements, first modify the Gemfile:

        source 'https://rubygems.org'

        gem 'sinatra', '~1.4.5'
        gem 'rack-cache'
        gem 'rack-bug'



    and then run:

        $ bundle install



-   If `bundle install` reports a conflict between your `Gemfile` and `Gemfile.lock`, run:

        $ bundle update sinatra



    This will update just the Sinatra gem, as well as any of its dependencies.

-   To update all of the gems in your `Gemfile` to the latest possible versions, run:

        $ bundle update



-   Whenever your `Gemfile.lock` changes, always check it in to version control. It keeps a history of the exact versions of all third-party code that you used to successfully run your application.
-   When deploying your code to a staging or production server, first run your tests (or boot your local development server), make sure you have checked in your `Gemfile.lock` to version control. On the remote server, run:

        $ bundle install --deployment
