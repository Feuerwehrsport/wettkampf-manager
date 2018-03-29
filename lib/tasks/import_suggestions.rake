namespace :import do
  desc 'Import fire sport statistics suggestions'
  task :suggestions, [:quiet] => :environment do |_task, args|
    FireSportStatistics::ImportSuggestions.new(args[:quiet].present?)
  end
end
