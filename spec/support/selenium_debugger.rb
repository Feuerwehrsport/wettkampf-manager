# frozen_string_literal: true

Capybara::Selenium::Driver.class_eval do
  def quit
    sleep 3
    puts 'Press RETURN to quit the browser'
    $stdin.gets
    @browser.quit
  rescue Errno::ECONNREFUSED
    puts 'Browser must have already gone'
  end
end

Capybara::Session.class_eval do
  def reset!; end
end

puts 'Warning: Rails.application.config.cache_classes is true' if Rails.application.config.cache_classes
