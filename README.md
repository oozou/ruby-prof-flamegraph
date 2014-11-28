ruby-prof-flamegraph
====================

A [ruby-prof][] printer that outputs a fold stack file that's compatible with [FlameGraph][].
It is created based on `RubyProf::CallStackPrinter`.


Awesomeness
-----------

[FlameGraph][] is a way to visualize stack trace,
making it very obvious where in the program takes the longest time.
It is a Perl script takes a "fold stack" file and generates a nice, interactive SVG.
The fold stack is usually generated from DTrace or Prof data using [stackcollapse.pl][FlameGraph], which is included with FlameGraph.

I created this gem because I want to find out where the bottleneck is in [SlimWiki][]'s specs,
but I don't know DTrace and just want the result quick.

I did not expect this,
but generating a company name from Faker causes 44 YAML files to be parsed,
taking 28 seconds.

(TODO include image)


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

Just `require 'ruby-prof-flamegraph` and use `RubyProf::FlameGraphPrinter` as your printer for ruby-prof.
For vanilla ruby-prof, see [example.rb](example.rb).

For rspec-prof, `RSpecProf.printer_class = RubyProf::FlameGraphPrinter`

[rspec-prof]: https://github.com/sinisterchipmunk/rspec-prof



## Example

See the result in [example.svg][]

[example.svg]: example.svg

