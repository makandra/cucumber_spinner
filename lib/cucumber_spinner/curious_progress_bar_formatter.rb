module CucumberSpinner

  class CuriousProgressBarFormatter < ProgressBarFormatter

    def after_table_row(*)
      @in_scenario_outline = true
      super
    ensure
      @in_scenario_outline = false
    end

    def failed!
      super
      if @in_scenario_outline
        puts "Cannot show you the page with the error, that does not work with scenario outlines."
        puts
      else
        show_the_page
      end
    end

    def show_the_page
      step_mother.step_match('show me the page').invoke(nil)
    rescue StandardError => e
      puts "Tried to show you the page with the error, but it failed due to #{e.class.name}: #{e.message}"
      puts
    end

  end

end

