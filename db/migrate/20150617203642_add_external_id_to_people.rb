class AddExternalIdToPeople < ActiveRecord::Migration
  def change
    add_column :people, :fire_sport_statistics_person_id, :integer
  end
end
