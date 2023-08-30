class AddShowBestOfRun < ActiveRecord::Migration[5.2]
  def change
    add_column :score_list_factories, :show_best_of_run, :boolean, null: false, default: false
    add_column :score_lists, :show_best_of_run, :boolean, default: false, null: false
  end
end
