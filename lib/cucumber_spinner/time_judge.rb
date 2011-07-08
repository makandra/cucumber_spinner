# fix the progress bar so it does not get confused by a possibly active TimeCop

module RTUI
  class Time < ::Time
    def self.mock_time
      nil
    end
  end
end
