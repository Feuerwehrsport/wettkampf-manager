# frozen_string_literal: true

module Score::ResultEntrySupport
  extend ActiveSupport::Concern
  ENTRY_STATUS = %i[waiting valid invalid no_run].freeze

  class_methods do
    def edit_time(method_name)
      define_method(:"second_#{method_name}") do
        loaded_time = send(method_name)
        return '' if loaded_time.blank? || loaded_time.zero?

        Firesport::Time.second_time(loaded_time)
      end

      define_method(:"edit_second_#{method_name}") do
        send(:"second_#{method_name}").tr(',', '.')
      end

      define_method(:"edit_second_#{method_name}=") do |new_second_time|
        send(:"second_#{method_name}=", new_second_time)
      end

      define_method(:"second_#{method_name}=") do |new_second_time|
        send(:"#{method_name}=", if (result = new_second_time.match(/^(\d+):(\d{1,2})[,.](\d{1,2})$/))
                                   result[1].to_i * 6000 + result[2].to_i * 100 + result[3].to_i
                                 elsif (result = new_second_time.match(/^(\d{1,4})[,.](\d)$/))
                                   result[1].to_i * 100 + (result[2].to_i * 10)
                                 elsif (result = new_second_time.match(/^(\d{1,3})[,.](\d\d)$/))
                                   result[1].to_i * 100 + result[2].to_i
                                 else
                                   new_second_time.to_i * 100
                                 end)
      end
    end
  end

  included do
    edit_time(:time)
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
