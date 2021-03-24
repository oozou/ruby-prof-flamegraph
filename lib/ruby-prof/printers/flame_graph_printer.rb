
require 'ruby-prof'

module RubyProf

  # wow much flame graph many stack wow!!
  #
  class FlameGraphPrinter < AbstractPrinter

    def print(output = STDOUT, options = {})
      setup_options(options)

      @result.threads.each do |thread|
        overall_time = thread.total_time
        start = []
        start << "Thread:#{thread.id}"
        start << "Fiber:#{thread.fiber_id}" unless thread.id == thread.fiber_id
        print_stack output, thread.call_tree, overall_time, start
      end
    end

    def min_time
      0
    end

    def print_stack(output, call_tree, overall_time, prefix)
      total_time = call_tree.total_time
      percent_total = (total_time/overall_time) * 100
      return unless percent_total > min_percent
      return unless total_time >= min_time

      current = prefix + [name(call_tree)]
      output.puts "#{current.join(';')} #{number call_tree.self_time * 1e3}"

      call_tree.children.each do |child|
        print_stack output, child, overall_time, current
      end
    end

    def name(call_info)
      method = call_info.target
      "#{method.full_name} (#{call_info.called})"
    end

    def number(x)
      ("%.6f" % x).sub(/\.0*$/, '').sub(/(\..*?)0+$/, '\1')
    end

  end

end

