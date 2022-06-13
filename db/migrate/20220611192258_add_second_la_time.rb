class AddSecondLaTime < ActiveRecord::Migration[5.2]
  def change
    add_column :score_list_factories, :separate_target_times, :boolean
    add_column :score_lists, :separate_target_times, :boolean, default: false, null: false
    add_column :score_list_entries, :time_left_target, :integer
    add_column :score_list_entries, :time_right_target, :integer
  end
end
