require 'ruby-prof'
require 'ruby-prof-flamegraph'

rubyprof_dir = Gem::Specification.find_by_name('ruby-prof').gem_dir
require "#{rubyprof_dir}/test/prime"

# Profile the code
result = RubyProf.profile do
  run_primes(200)
end

# Print a graph profile to text
printer = RubyProf::FlameGraphPrinter.new(result)
printer.print(STDOUT, {})
