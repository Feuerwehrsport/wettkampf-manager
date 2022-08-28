class AddSingleCompetitorsFirstToScoreListFactories < ActiveRecord::Migration[5.2]
  def change
    add_column :score_list_factories, :single_competitors_first, :boolean
  end
end
