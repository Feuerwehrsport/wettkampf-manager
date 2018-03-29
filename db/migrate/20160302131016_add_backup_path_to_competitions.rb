class AddBackupPathToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :backup_path, :string, default: '', null: false
  end
end
