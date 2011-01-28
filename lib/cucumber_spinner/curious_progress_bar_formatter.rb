module CucumberSpinner

  class CuriousProgressBarFormatter < ProgressBarFormatter

    def failed!
      super
      show_the_page
    end

    def show_the_page
      step_mother.step_match('show me the page').invoke(nil)
    rescue StandardError => e
      puts "Tried to show you the page the page with the error, but it failed due to #{e.class.name}: #{e.message}"
    end

  end

end

