class CreateBands < ActiveRecord::Migration[5.2]
  def change
    create_table :bands do |t|
      t.integer :gender, null: false
      t.string :name, null: false
      t.integer :position

      t.timestamps
    end

    remove_index :teams, name: :index_teams_on_name_and_number_and_gender

    add_column :assessments, :band_id, :integer
    add_column :teams, :band_id, :integer
    add_column :people, :band_id, :integer
    add_column :score_competition_results, :band_id, :integer

    change_column_null :assessments, :band_id, false
    change_column_null :teams, :band_id, false
    change_column_null :people, :band_id, false
    change_column_null :score_competition_results, :band_id, false

    remove_column :assessments, :gender
    remove_column :teams, :gender
    remove_column :people, :gender
    remove_column :score_competition_results, :gender

    add_index :teams, %i[name number band_id]

    remove_column :score_list_factories, :gender

    create_table :bands_score_list_factories, id: false do |t|
      t.belongs_to :band
      t.belongs_to :list_factory
    end

    change_column_default :score_list_factories, :single_competitors_first, true
  end
end
