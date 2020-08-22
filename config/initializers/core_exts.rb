Dir[Rails.root.join('lib/core_ext/*.rb')].sort.each { |l| require l }
