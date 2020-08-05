# frozen_string_literal: true

class ChangeBooleanDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :competitions, :configured, nil
    change_column_default :competitions, :configured, 0
    change_column_default :competitions, :group_assessment, nil
    change_column_default :competitions, :group_assessment, 0
    change_column_default :competitions, :show_bib_numbers, nil
    change_column_default :competitions, :show_bib_numbers, 0
    change_column_default :competitions, :lottery_numbers, nil
    change_column_default :competitions, :lottery_numbers, 0
    change_column_default :competitions, :hide_competition_results, nil
    change_column_default :competitions, :hide_competition_results, 0
    change_column_default :disciplines, :like_fire_relay, nil
    change_column_default :disciplines, :like_fire_relay, 0
    change_column_default :fire_sport_statistics_people, :dummy, nil
    change_column_default :fire_sport_statistics_people, :dummy, 0
    change_column_default :fire_sport_statistics_teams, :dummy, nil
    change_column_default :fire_sport_statistics_teams, :dummy, 0
    change_column_default :imports_tags, :use, nil
    change_column_default :imports_tags, :use, 1
    change_column_default :score_results, :group_assessment, nil
    change_column_default :score_results, :group_assessment, 0
  end
end
