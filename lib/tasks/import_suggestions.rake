namespace :import do
  desc "Import fire sport statistics suggestions"
  task :suggestions, [] => :environment do |task, args|
    FireSportStatistics::ImportSuggestions.new
  end

  desc "Import fire sport statistics suggestions"
  task :d_cup_results, [] => :environment do |task, args|
    FireSportStatistics::ImportDCupResults.new
  end
end