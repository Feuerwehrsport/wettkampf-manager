class AddFlyerTextToCompetition < ActiveRecord::Migration[4.2]
  def change
    add_column :competitions, :flyer_text, :text, null: false, default: ''
  end
end
