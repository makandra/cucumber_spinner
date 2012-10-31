require 'cucumber_spinner/formatted_io'
require 'cucumber/formatter/io'
require 'cucumber/formatter/pretty'
require 'rtui'

module CucumberSpinner

  class ProgressBarFormatter
    include Cucumber::Formatter::Io

    attr_reader :step_mother

    def initialize(step_mother, path_or_io, options)
      @step_mother, @io, @options = step_mother, ensure_io(path_or_io, "progress"), options
      @error_state = :passed
      @coloured_io = CucumberSpinner::FormattedIo.new(@io)
      @coloured_io.status = @error_state
      @pretty_printer_io = StringIO.new
      @pretty_printer = Cucumber::Formatter::Pretty.new(step_mother, @pretty_printer_io, options)
    end


    def before_features(features)
      @current = 0
      @total = get_step_count(features)
      @progress_bar = RTUI::Progress.new("#{@total} steps", @total, {:out => @coloured_io})
    end

    def after_step_result(keyword, step_match, multiline_arg, status, exception, source_indent, background)
      increment

      case status
      when :pending then pending!
      when :failed then failed!
      when :undefined then undefined!
      end
    end

    def after_table_row(row)
      increment
      @pretty_printer.after_table_row(row)
      if row.exception
        failed!
      end
    end

    def after_features(features)
      @io.puts
      @io.puts
      clear_pretty_output
      @pretty_printer.after_features(features)
      print_pretty_output
    end

    def before_feature_element(feature_element)
      clear_pretty_output
      @pretty_printer.before_feature_element(feature_element)
    end

    def self.delegate_to_pretty_printer(*methods)
      methods.each do |method|
        define_method(method) do |*args|
          @pretty_printer.send(method, *args)
        end
      end
    end
    delegate_to_pretty_printer :before_feature, :comment_line, :after_tags, :tag_name, :feature_name, :after_feature_element, :before_background, :after_background, :background_name, :before_examples_array, :examples_name, :before_outline_table, :after_outline_table, :scenario_name, :before_step, :before_step_result, :step_name, :py_string, :exception, :before_multiline_arg, :after_multiline_arg, :before_table_row, :after_table_cell, :table_cell_value


    private

    def clear_pretty_output
      @pretty_printer_io.truncate(0)
    end

    def print_pretty_output
      @io.print @pretty_printer_io.string
    end

    def print_scenario
      erase_current_line
      print_pretty_output
      @io.puts
    end

    def erase_current_line
      @io.print "\e[K"
    end

    def increment
      with_color do
        @current += 1
        # HACK: need to make sure the progress is printed, even when the bar hasn't changed
        @progress_bar.instance_variable_set("@previous", 0)
        @progress_bar.instance_variable_set("@title", "#{@current}/#{@total}")
        @progress_bar.inc
      end
      @io.flush
    end

    # stolen from the html formatter
    def get_step_count(features)
      count = 0
      features = features.instance_variable_get("@features")
      features.each do |feature|
        #get background steps
        if feature.instance_variable_get("@background")
          background = feature.instance_variable_get("@background")
          background.init
          background_steps = background.instance_variable_get("@steps").instance_variable_get("@steps")
          count += background_steps.size
        end
        #get scenarios
        feature.instance_variable_get("@feature_elements").each do |scenario|
          scenario.init
          #get steps
          steps = scenario.instance_variable_get("@steps").instance_variable_get("@steps")
          count += steps.size

          #get example table
          examples = scenario.instance_variable_get("@examples_array")
          unless examples.nil?
            examples.each do |example|
              example_matrix = example.instance_variable_get("@outline_table").instance_variable_get("@cell_matrix")
              count += example_matrix.size
            end
          end

          #get multiline step tables
          steps.each do |step|
            multi_arg = step.instance_variable_get("@multiline_arg")
            next if multi_arg.nil?
            matrix = multi_arg.instance_variable_get("@cell_matrix")
            count += matrix.size unless matrix.nil?
          end
        end
      end
      return count
    end

    def pending!
      @error_state = :pending if @error_state == :passed
    end

    def undefined!
      @error_state = :undefined unless @error_state == :failed
      print_scenario
    end

    def failed!
      @error_state = :failed
      print_scenario
    end

    def with_color
      @coloured_io.status = @error_state
      yield
    end

  end

end
