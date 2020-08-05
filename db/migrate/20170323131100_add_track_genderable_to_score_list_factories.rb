# frozen_string_literal: true

class AddTrackGenderableToScoreListFactories < ActiveRecord::Migration[4.2]
  def change
    add_column :score_list_factories, :track, :integer
    add_column :score_list_factories, :gender, :integer
  end
end
