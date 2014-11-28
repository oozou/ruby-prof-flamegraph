
require 'ruby-prof'

module RubyProf

  # wow much flame graph many stack wow!!
  #
  class FlameGraphPrinter < AbstractPrinter

    VERSION = '0.2.0'

    def print(output = STDOUT, options = {})
      @output = output
      setup_options(options)

      @overall_threads_time = @result.threads.reduce(0) { |a, thread| a + thread.total_time }

      @result.threads.each do |thread|
        @current_thread_id = thread.fiber_id
        @overall_time = thread.total_time
        start = []
        start << "Thread:#{thread.id}"
        start << "Fiber:#{thread.fiber_id}" unless thread.id == thread.fiber_id
        thread.methods.each do |m|
          next unless m.root?
          m.call_infos.each do |ci|
            next unless ci.root?
            print_stack start, ci
          end
        end
      end
    end

    def min_time
      0
    end
    
    def print_stack(prefix, call_info)

      total_time = call_info.total_time
      percent_total = (total_time/@overall_time)*100
      return unless percent_total > min_percent
      return unless total_time >= min_time

      kids = call_info.children
      current = prefix + [name(call_info)]
      @output.puts "#{current.join(';')} #{number call_info.self_time * 1e3}"

      kids.each do |child|
        print_stack current, child
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

