class AddYouthToFireSportStatisticsPeople < ActiveRecord::Migration
  def change
    add_column :fire_sport_statistics_people, :youth, :boolean, default: false, null: false
  end
end
