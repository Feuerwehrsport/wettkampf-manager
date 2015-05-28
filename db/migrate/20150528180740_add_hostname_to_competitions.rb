class AddHostnameToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :hostname, :string, default: "", null: false
  end
end
