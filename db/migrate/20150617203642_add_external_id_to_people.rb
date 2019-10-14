class AddExternalIdToPeople < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :fire_sport_statistics_person_id, :integer
  end
end
