class AddBackupPathToCompetitions < ActiveRecord::Migration[4.2]
  def change
    add_column :competitions, :backup_path, :string, default: '', null: false
  end
end
