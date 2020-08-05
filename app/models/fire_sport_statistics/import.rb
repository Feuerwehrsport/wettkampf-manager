# frozen_string_literal: true

class FireSportStatistics::Import
  protected

  def fetch(key, params = nil)
    print_percent(key, 1, 0) unless @quiet
    collection = FireSportStatistics::API::Get.fetch(key, params)
    count = collection.count
    collection.each_with_index do |entry, index|
      yield(entry)
      print_percent(key, count, index) unless @quiet
    end
    print_percent(key, 1, 1) unless @quiet
    puts '' unless @quiet # rubocop:disable Rails/Output
  end

  def print_percent(key, count, index)
    print "#{key}: #{(index.to_f / count * 100).round}%\r" # rubocop:disable Rails/Output
    STDOUT.flush
  end
end
