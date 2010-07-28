require 'cucumber/formatter/console'

module CucumberSpinner

  class FormattedIo
    include Cucumber::Formatter::Console

    attr_writer :status

    def initialize(io)
      @io = io
    end

    def print(string)
      @io.print(format_string(string, @status))
    end

    def method_missing(method_name, *args)
      @io.send(method_name, *args)
    end
  end

end
