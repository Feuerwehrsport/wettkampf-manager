module Score::ResultEntrySupport
  ENTRY_STATUS = %i[waiting valid invalid no_run].freeze

  def second_time
    return '' if time.blank? || time .zero?
    seconds = time.to_i / 100
    millis = time.to_i % 100
    "#{seconds},#{format('%02d', millis)}"
  end

  def edit_second_time
    second_time.tr(',', '.')
  end

  def edit_second_time=(new_second_time)
    self.second_time = new_second_time
  end

  def second_time=(new_second_time)
    self.time = if result = new_second_time.match(/^(\d+):(\d{1,2})[,.](\d{1,2})$/)
                  result[1].to_i * 6000 + result[2].to_i * 100 + result[3].to_i
                elsif result = new_second_time.match(/^(\d{1,4})[,.](\d)$/)
                  result[1].to_i * 100 + (result[2].to_i * 10)
                elsif result = new_second_time.match(/^(\d{1,3})[,.](\d\d)$/)
                  result[1].to_i * 100 + result[2].to_i
                else
                  new_second_time.to_i * 100
                end
  end

  def time_with_valid_calculation=(time)
    self.time = time
    self.result_valid = time.present? && time < Firesport::INVALID_TIME
  end

  def result_valid=(valid)
    self.result_type = valid ? :valid : :invalid
  end

  def result_type
    super.try(:to_sym)
  end

  def result_valid?
    result_type == :valid
  end

  def result_waiting?
    result_type == :waiting
  end

  def result_invalid?
    result_type == :invalid
  end

  def result_no_run?
    result_type == :no_run
  end

  def compare_time
    result_valid? && time < Firesport::INVALID_TIME ? time : Firesport::INVALID_TIME
  end

  def <=>(other)
    compare_time <=> other.compare_time
  end
end
