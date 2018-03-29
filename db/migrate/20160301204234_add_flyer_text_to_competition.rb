class AddFlyerTextToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :flyer_text, :text, null: false, default: ''
  end
end
