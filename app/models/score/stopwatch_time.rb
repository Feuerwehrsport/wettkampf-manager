module Score
  class StopwatchTime < ActiveRecord::Base
    INVALID_TIME = 999999999999
    
    belongs_to :list_entry

    validates :list_entry, :time, presence: true
    validates :time, numericality: { greater_than: 0 }

    def self.aggregated_time(time, valid=nil)
      if time.is_a?(StopwatchTime)
        time.list_entry = ListEntry.new(result_type: time.time.present? ? "valid" : "invalid")
        return time
      end
      valid = time.present? if valid.nil?
      new(time: time, list_entry: ListEntry.new(result_type: valid ? "valid" : "invalid"))
    end

    def second_time
      return "" if time.blank? || time == 0
      sprintf("%.2f", (time.to_f/100)).sub(".", ",")
    end

    def second_time= new_second_time
      self.time = (new_second_time.sub(",", ".").sub(":", ".").to_f * 100).round
    end

    def <=> other
      (time || INVALID_TIME) <=> (other.time || INVALID_TIME)
    end
  end
end
