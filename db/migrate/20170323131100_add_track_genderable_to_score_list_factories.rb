class AddTrackGenderableToScoreListFactories < ActiveRecord::Migration
  def change
    add_column :score_list_factories, :track, :integer
    add_column :score_list_factories, :gender, :integer
  end
end
