[A Guide to Ruby Collections, Part I: Arrays — SitePoint](https://www.sitepoint.com/guide-ruby-collections-part-arrays/)

Programming consists largely of sorting and searching. In an older language like C, you might be expected to write your own data structures and algorithms for these tasks. However, with Ruby these constructs have been abstracted away in favor of the ability to focus on the task at hand.

What follows is a guide to these abstractions. It isn’t completely comprehensive-an entire book could be written on Ruby collections-but I cast a wide net, and I cover what I think you will encounter often as a Ruby programmer. It is broken into 4 parts:

1.  Arrays and Iteration
2.  Hashes, Sets, and Ranges
3.  Enumerable and Enumerator
4.  Tricks and Tips

This is a highly example-driven guide. I think the best way to learn this stuff is to just pop open an irb shell and follow along, creating your own clever variations along the way.

## Arrays

Arrays are the workhorses of Ruby collections. Most methods operating on collections will return an Array as a result, even if the original collection was not one. In truth, they aren’t really arrays at all, but a kind of one-size-fits-all data structure. You can make them act like sets, stacks, or queues. They are the functional equivalent of Python lists.

### Creation

Ruby arrays are created similarly to those found in other dynamic languages.

    >numbers = [1, 0, 7]
    >numbers[2]
    =7
    >numbers.size
    =3

Arrays do not need to consist of the same data type. They can be heterogeneous.

    >data = ["bob", 3, 0.931, true]

Since Ruby is completely object-oriented, arrays are represented as objects rather than merely special interpreter rules. This means you can construct them like other objects.

    >numbers = Array.new([1,2,3]) 
    =[1, 2, 3]

The array constructor can be passed a starting size, but it might not work like you expect. Since Ruby arrays are dynamic, it isn’t necessary to preallocate space for them. When you pass in a number by itself to Array#new, an Array with that many nil objects is created.

    >numbers = Array.new(3)
    =[nil, nil, nil]

Although nil is a singleton object, it takes up a slot in collections like any other object. So when you add an element to an Array of nil objects, it gets tacked onto the end.

    >numbers << 3
    =[nil, nil, nil, 3]
    >numbers.size
    =4

If you pass Array#new a second argument, it becomes the fill value instead of nil.

    >Array.new(3, 0)
    =[0, 0, 0] 
    
    >Array.new(3, :DEFAULT)
    =[:DEFAULT, :DEFAULT, :DEFAULT]

In addition to the standard literal, Ruby provides some other syntax shortcuts through [%notation](http://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Literals#The_.25_Notation).

    >ORD = "ord"
    >%W{This is an interpolated array of w#{ORD}s}
    =["This", "is", "an", "interpolated", "array", "of", "words"] 
    
    >%w{This is a non-interpolated array of w#{ORD}s}
    =["This", "is", "a", "non-interpolated", "array", "of", "w\#{ORD}s"]

### Array Indices

Most languages will throw an exception if you attempt to access an array index that does not yet exist. If you attempt to read a non-existent index, Ruby returns nil.

    >spanish_days = []
    >spanish_days[3]
    =nil

If you write to a non-existent index, Ruby will insert nil into the array up to that index.

window.propertag.cmd.push(function() { proper\_display('sitepoint\_content_1'); });

    >spanish_days[3] = "jueves"  
    =[nil, nil, nil, "jueves"] 
    >spanish_days[6] = "domingo" 
    =[nil, nil, nil, "jueves", nil, nil, "domingo"]

Most languages will also error out if you try to access a negative array index. Ruby considers negative indices to start at the end of the array, working back towards the beginning as they increase.

    >["a","b","c"][-1]
    ="c"
    >["a","b","c"][-3]
    ="a"

If you provide a nonexistent, negative array index, the result is the same as a nonexistent, positive one – nil

    >["a","b","c"][-4]
    =nil

### Array Ranges

Another useful feature of Ruby arrays is the ability to access ranges of elements. However, they can be tricky given that there are many different ways to specify a range of elements in Ruby.

    >letters = %w{a b c d e f}
    =["a", "b", "c", "d", "e", "f"]
    >letters[0..1]
    =["a", "b"]
    >letters[0, 2]
    =["a", "b"]
    >letters[0...2]
    =["a", "b"]
    >letters[0..-5]
    =["a", "b"]
    >letters[-6, 2]
    =["a", "b"]

Here are the reasonings behind these examples:

1.  letters\[0..1\] – give me elements 0 through 1
2.  letters\[0, 2\] – starting with index 0, give me 2 elements
3.  letters\[0…2\] – give me elements 0 until 2
4.  letters\[0..-5\] – give me elements 0 through -5
5.  letters\[-6, 2\] – starting with element -6, give me 2 elements

If you are new to Ruby, you might be wondering how this is even possible. It turns out that array accesses are nothing more than calls to the #\[\] method.

    >letters.[](0..1)
    =["a", "b"]

In addition, 0..1 is nothing more than a Range object in disguise. You can verify this by using the #class method.

    >(0..1).class
    =Range

So what is really going on is a Range object representing the target range of elements is passed to Array#\[\].

    >letters.[](Range.new(0,1))
    =["a", "b"]

This object-oriented nature of Ruby enables us to do some pretty crazy things, if we like. What if we wanted to use numbers in the form of English words?

The numerouno gem can be used to parse English numbers.

    $ gem install numerouno
    
    >require 'numerouno'
    >"one-hundred sixty three".as_number
    =163

With numerouno you can now make an array class that takes English indices.

    class EnglishArray < Array
      def [](idx)     
        if String === idx
          self.at(idx.as_number)  
        end
      end
    end 
    
    >arr = EnglishArray.new(["a","b","c"])
    >arr["one"]
    ="b"

### Transformation

Remember how I said Ruby’s Array is a one-size-fits-all data structure? Here are some examples of the kinds of operations you can perform on Array.

**Adding Elements**

    >[1,2,3] << "a" 
    =[1,2,3,"a"]
    
    >[1,2,3].push("a")
    =[1,2,3,"a"]
    
    >[1,2,3].unshift("a")
    =["a",1,2,3]
    
    >[1,2,3] << [4,5,6]
    =[1,2,3,[4,5,6]]

**Removing Elements**

window.propertag.cmd.push(function() { proper\_display('sitepoint\_content_2'); });

    >arr = [1,2,3]
    >arr.pop
    =3
    >arr
    =[1,2]
    
    >arr = ["a",1,2,3]
    >arr.shift
    ="a"
    >arr
    =[1,2,3]
    
    >arr = [:a, :b, :c]
    >arr.delete(:b)
    =:b
    >arr
    =[:a, :c]
    >arr.delete_at(1)
    =:c
    >arr
    =[:a]

**Combining Arrays**

    >[1,2,3] + [4,5,6]
    =[1,2,3,4,5,6]
    
    >[1,2,3].concat([4,5,6])
    =[1,2,3,4,5,6]
    
    >["a",1,2,3,"b"] - [2,"a","b"]
    =[1,3]

**Boolean Operations**

    >[1,2,3] & [2,3,4]
    =[2,3]
    
    >[1,2,3] | [2,3,4]
    =[1,2,3,4]
    
    >arr1 = [1,2,3]
    >arr2 = [2,3,4]
    >xor = arr1 + arr2 - (arr1 & arr2)
    =[1,4]

**Moving Elements**

    >[1,2,3].reverse
    =[3,2,1]
    
    >[1,2,3].rotate
    =[2,3,1]
    
    >[1,2,3].rotate(-1)
    =[3,1,2]

**Safeguarding**

    >arr = [1,2,3]
    >arr.freeze
    >arr << 4  
    =RuntimeError: can't modify frozen Array

**Combining Elements Into a String**

    >words = ["every","good","boy","does","fine"]
    >words.join
    ="everygoodboydoesfine"
    
    >words.join(" ")
    ="every good boy does fine"

**Removing Nesting**

    >[1,[2,3],[4,["a", nil]]].flatten
    =[1,2,3,4,"a",nil]
    
    >[1,[2,3],[4,["a", nil]]].flatten(1)
    =[1,2,3,4,["a", nil]]

**Removing Duplicates**

    >[4,1,2,1,5,4].uniq
    =[4,1,2,5]

**Slicing**

    >arr = [1,2,3,4,5]
    >arr.first(3)
      =[1,2,3]
    
    >arr.last(3)
    =[3,4,5]

**Querying**

    >["a","b","c"].include? "d"
    =false
    
    >["a", "a", "b"].count "a"
    =2
    
    >["a", "a", "b"].count "b"
    =1
    
    >[1,2,[3,4]].size
    =3

### Iteration

Iteration is an area where Ruby really shines. In many languages iteration feels awkwardly tacked on. However, in Ruby you should never feel the need to write a classical for loop.

The central construct in Ruby iteration is the #each method.

    >["first", "middle", "last"].each { |i| puts i.capitalize }
    First
    Middle
    Last

Although #each is the core iterator in Ruby, there are **many** others. For example, you can iterate through a collection backwards by using #reverse_each.

    >["first", "middle", "last"].reverse_each { |i| puts i.upcase }
    LAST
    MIDDLE
    FIRST

Another handy method is #each\_with\_index which passes the current index as the second argument to the block.

window.propertag.cmd.push(function() { proper\_display('sitepoint\_content_3'); });

    >["a", "b", "c"].each_with_index do |letter, index| 
    >  puts "#{letter.upcase}: #{index}"
    >end
    A: 0
    B: 1
    C: 2

How, exactly, does this #each method work? The best way to understand is to make your own #each.

    class Colors
      def each
        yield "red"
        yield "green"
        yield "blue"
      end
    end
    
    >c = Colors.new
    >c.each { |i| puts i }
    red
    green
    blue

The #yield method calls the block you pass to #each. This can be difficult for many ruby newcomers to wrap their heads around. Think of #yield as calling an anonymous body of code that you provide to the method #yield is in. In the previous example, yield is called three times, so “{ |i| puts i }” runs three times.

### Partial Iteration

One of the nice things about for loops is that beginning and ending points can be specified. #each, however, always iterates through an entire collection.

If you need to iterate through only part of a collection, there are at least a couple ways of doing this:

Slice the collection and then iterate through the slice

    >[1,2,3,4,5][0..2].each { |i| puts i }
    1
    2
    3

Use a Range to generate indices

    >arr = [1,2,3,4,5]
    >(0..2).each { |i| puts arr[i] }
    1
    2
    3

Although it’s a bit uglier, I’m willing to bet that option 2 is more efficient as Array element sizes get larger and take longer to copy.

### #each vs. #map/#collect

In addition to #each, you will likely encounter #map quite often as well. #map is like #each except it builds an Array out of the results of each block call. This is useful because #each only returns the caller.

    >[1,2,3].each { |i| i + 1 }
    =[1,2,3]
    
    >[1,2,3].map { |i| i + 1 }
    =[2,3,4]

If you’re just calling a method on each element, you can use a handy shortcut.

    >[1,2,3].map(&:to_f)
    =[1.0, 2.0, 3.0]

Which is the same as:

    >[1,2,3].map { |i| i.to_f }
    =[1.0, 2.0, 3.0]

Note that #map does not alter the original collection. It merely returns an array based on the result of each block call. If you want the original collection to reflect the changes, use #map! instead.

    >numbers = [1,2,3]
    >numbers.map(&:to_f)
    =[1.0, 2.0, 3.0]
    >numbers
    =[1, 2, 3]
    >numbers.map!(&:to_f)
    =[1.0, 2.0, 3.0]
    >numbers
    =[1.0, 2.0, 3.0]

You may have noticed #collect in Ruby code as well. It’s identical to #map, so  
the two are interchangeable.

    >letters = ["a", "b", "c"]
    >letters.map(&:capitalize)
    =["A", "B", "C"]
    >letters.collect(&:capitalize)
    =["A", "B", "C"]

### Classical Iteration

Ruby provides the classical “for” idiom. Although it looks cleaner and is more familiar to newcomers from other languages, it is un-idiomatic since it is not object-oriented and does not accept a block.

    >animals = ["cat", "dog", "bird", "chuck testa"]
    >for animal in animals
    >  puts animal.upcase
    >end
    CAT
    DOG
    BIRD
    CHUCK TESTA