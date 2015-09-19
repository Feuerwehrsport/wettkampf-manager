namespace :import do
  desc "Import fire sport statistics suggestions"
  task :suggestions, [] => :environment do |task, args|
    FireSportStatistics::ImportSuggestions.new true
  end

  desc "Import fire sport statistics suggestions"
  task :d_cup_results, [] => :environment do |task, args|
    FireSportStatistics::ImportDCupResults.new true
  end
end