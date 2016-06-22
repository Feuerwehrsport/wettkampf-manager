class AddDummyToFireSportStatisticsPeople < ActiveRecord::Migration
  def change
    add_column :fire_sport_statistics_people, :dummy, :boolean, null: false, default: false
  end
end
