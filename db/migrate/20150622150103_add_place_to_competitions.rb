class AddPlaceToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :place, :string, null: false, default: ""
  end
end
