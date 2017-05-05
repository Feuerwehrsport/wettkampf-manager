class ModelCache
  def self.clean
    Competition.one.touch
    FireSportStatistics::Person.dummies.delete_all    
    FireSportStatistics::Team.dummies.delete_all    
  end
end