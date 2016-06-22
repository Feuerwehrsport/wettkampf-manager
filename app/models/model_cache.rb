class ModelCache
  def self.clean
    FireSportStatistics::Person.dummies.delete_all    
    FireSportStatistics::Team.dummies.delete_all    
  end
end