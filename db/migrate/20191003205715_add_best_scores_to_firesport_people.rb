class AddBestScoresToFiresportPeople < ActiveRecord::Migration
  def change
    add_column :fire_sport_statistics_people, :personal_best_hb, :integer
    add_column :fire_sport_statistics_people, :personal_best_hb_competition, :string
    add_column :fire_sport_statistics_people, :personal_best_hl, :integer
    add_column :fire_sport_statistics_people, :personal_best_hl_competition, :string
    add_column :fire_sport_statistics_people, :personal_best_zk, :integer
    add_column :fire_sport_statistics_people, :personal_best_zk_competition, :string

    add_column :fire_sport_statistics_people, :saison_best_hb, :integer
    add_column :fire_sport_statistics_people, :saison_best_hb_competition, :string
    add_column :fire_sport_statistics_people, :saison_best_hl, :integer
    add_column :fire_sport_statistics_people, :saison_best_hl_competition, :string
    add_column :fire_sport_statistics_people, :saison_best_zk, :integer
    add_column :fire_sport_statistics_people, :saison_best_zk_competition, :string
  end
end
