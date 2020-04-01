# Ruby installation and versions management

## Ruby and rbenv
 
OS X comes with Ruby built-in, but I highly recommend installing Ruby with [rbenv](https://github.com/rbenv/rbenv). With rbenv, you can specify the version of Ruby you want installed.


### Installing rbenv on a mac
```bash
$ brew install rbenv
```

Then launch a new terminal, and ensure rbenv is picked up

List available versions of ruby on your machine

```bash
$ rbenv versions
  system
  2.5.3
* 2.6.5 (set by ...something/.ruby-version)
```

### Install a given ruby

Let's install ruby version 2.4.2

```bash
$ rbenv install 2.4.2
```

### Pick the right ruby version in a project

Create a file named `.ruby-version` to the root of your project folder

```bash 
$ echo "2.4.2" > .ruby-version
```

When you (re-)enter that folder rbenv will choose the ruby 2.4.2 if installed or otherwise ask you to install it

```bash
$ cd .
$ rbenv version
2.4.2 (set by ...something/.ruby-version)
```

```bash
$ ruby -v
  ruby 2.4.2 ...
```

### Set your global ruby

Install a recent version of ruby e.g. 2.6.5 and run

```bash
$ rbenv global 2.6.5
```

Now 2.6.5 will be used everywhere except in folders where a .ruby-version file defines otherwise.

