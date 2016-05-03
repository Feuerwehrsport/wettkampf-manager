namespace :import do
  desc "Import fire sport statistics suggestions"
  task :suggestions, [] => :environment do |task, args|
    FireSportStatistics::ImportSuggestions.new
  end
end