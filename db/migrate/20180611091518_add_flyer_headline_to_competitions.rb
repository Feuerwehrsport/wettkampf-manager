class AddFlyerHeadlineToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :flyer_headline, :string
  end
end
