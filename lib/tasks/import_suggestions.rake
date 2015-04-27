desc "Import fire sport statistics suggestions"
task :import_suggestions, [] => :environment do |task, args|
  FireSportStatistics::ImportSuggestions.new true
end
