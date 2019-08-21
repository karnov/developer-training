# Ruby installation and versions management

## Ruby and RVM
 
OS X comes with Ruby built-in, but I highly recommend installing Ruby with [RVM](http://rvm.io). With RVM, you can specify the version of Ruby you want installed.


### Installing RVM on a mac
```bash
$ gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

§ \curl -sSL https://get.rvm.io | bash
```

List available rubies

```bash
$ rvm list

      jruby-9.2.6.0 [ x86_64 ]
      ruby-2.4.2 [ x86_64 ]
      ruby-2.5.1 [ x86_64 ]
      ruby-2.5.3 [ x86_64 ]
  =*  ruby-2.6.3 [ x86_64 ]

  # => - current
  # =* - current && default
  #  * - default
```

### Pick the right ruby version in a project

Create a file named `.ruby-version` to the root of your project folder

```bash 
$ echo "ruby-2.4.2" > .ruby-version
```

When you (re-)enter that folder RVM will choose the ruby 2.4.2

```bash
$ cd .
$ rvm current
  ruby-2.6.3
```

```bash
$ ruby -v
  ruby 2.6.3p62 (2019-04-16 revision 67580) ...
```

