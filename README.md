ruby-prof-flamegraph
====================

Easily find the bottleneck in your Ruby app.

RubyProf::FlameGraphPrinter is a [ruby-prof][] printer
that outputs a fold stack file that's compatible with [FlameGraph][].
It is created based on `RubyProf::CallStackPrinter`.

The result can be passed to [FlameGraph][] to generate an interactive stack trace visualization
(click on the image to see the demo).

[Demo]: https://cdn.rawgit.com/oozou/ruby-prof-flamegraph/7ef5b567d9287d5de00d080e2b3abc2b05356e9f/example.svg

[![Demo][Demo]][Demo]


Awesomeness
-----------

[FlameGraph][] is a way to visualize stack trace,
making it very obvious where in the program takes the longest time.
It is a Perl script takes a "fold stack" file and generates a nice, interactive SVG.
The fold stack is usually generated from DTrace or Prof data using [stackcollapse.pl][FlameGraph], which is included with FlameGraph.

I created this gem because I want to find out where the bottleneck is in [SlimWiki][]'s specs,
but I don't know DTrace and just want the result quick.



To learn more about Flame Graphs, check these out:

- [Official Flame Graphs Website](http://www.brendangregg.com/flamegraphs.html) by [Brendan Gregg](http://www.brendangregg.com/)
- [Node.js in Flames](http://techblog.netflix.com/2014/11/nodejs-in-flames.html), which is the article that introduced me to flame graph (via [Node Weekly Issue #62](http://nodeweekly.com/issues/62))
- [Blazing Performance with Flame Graphs](https://www.usenix.org/conference/lisa13/technical-sessions/plenary/gregg) talk at USENIX/LISA13 ([slideshare](http://www.slideshare.net/brendangregg/blazing-performance-with-flame-graphs?ref=http://www.brendangregg.com/flamegraphs.html)) ([video](http://www.youtube.com/watch?v=nZfNehCzGdw))



[ruby-prof]: https://github.com/ruby-prof/ruby-prof
[FlameGraph]: https://github.com/brendangregg/FlameGraph
[SlimWiki]: https://slimwiki.com/


## Installation

```ruby
gem 'ruby-prof-flamegraph'
```


## Usage


### Obtaining the Fold Stack Trace

Just `require 'ruby-prof-flamegraph'` and use `RubyProf::FlameGraphPrinter` as your printer for ruby-prof.
For vanilla ruby-prof, see [example.rb](example.rb).

For rspec-prof, `RSpecProf.printer_class = RubyProf::FlameGraphPrinter`


### Generating the Image

Then, to generate an image, pipe the output to [FlameGraph][]'s `flamegraph.pl`. Here's how the example SVG is generated:

```bash
bundle exec ruby example.rb | \
    ~/GitHub/FlameGraph/flamegraph.pl --countname=ms --width=728 > example.svg
```


[rspec-prof]: https://github.com/sinisterchipmunk/rspec-prof



## Output Format

Taken from [`flamegraph.pl`]:

> The input is stack frames and sample counts formatted as single lines.  Each
> frame in the stack is semicolon separated, with a space and count at the end
> of the line.

Each line in the output looks like this:

```
Thread:ID;Fiber:ID;Class#method1 (call_count) time_taken_in_milliseconds
```

Here's an example:

```
Thread:123;Fiber:123;Capybara::Server#boot (1) 0.163681
Thread:123;Fiber:123;Capybara::Server#boot (1);<Module::Capybara>#server (1) 0.099445
Thread:123;Fiber:123;Capybara::Server#boot (1);<Module::Capybara>#server (1);Kernel#block_given? (1) 0.044838
Thread:123;Fiber:123;Capybara::Server#boot (1);Proc#call (1) 0.019682
Thread:123;Fiber:123;Capybara::Server#boot (1);Proc#call (1);<Module::Capybara>#run_default_server (1) 0.147611
```

The call count is included so that the number of calls is shown in the graph.


### Post-Processing

Sometimes, you may want to post process the data before passing it to `flamegraph.pl`, such as...

- #### Removing the Thread and Fiber ID

  Capybara spawns new WEBrick thread each time, putting each HTTP server instance in a different stack.
  We can strip the Thread ID and Fiber ID from the output first:

  ```ruby
  processed = 0

  while data = gets
    data.gsub! %r{^Thread:\d+;Fiber:\d+;}, ''
    puts data
    processed += 1
    if processed % 1000 == 0
      $stderr.puts "Processed #{processed} lines"
    end
  end

  $stderr.puts "Finished processing #{processed} lines"
  ```

  ```bash
  ruby remove-thread-id.rb < profile.txt > profile2.txt
  ```

- #### Removing call counts

  Sometimes, you may want to concatenate multiple profiles.
  This causes the stack to separate based on the call count.
  To put calls to same method on the same stack, the call count should be removed.

  ```ruby
  processed = 0

  while data = gets
    data.gsub! %r{\s\(\d+\);}, ';'
    puts data
    processed += 1
    if processed % 1000 == 0
      $stderr.puts "Processed #{processed} lines"
    end
  end

  $stderr.puts "Finished processing #{processed} lines"
  ```

  ```bash
  ruby remove-call-count.rb < profile2.txt > profile3.txt
  ```


I am relying on external scripts to do this processing for maximum flexibility
(so that I always have the raw data to adjust it as needed).




